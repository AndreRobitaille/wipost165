require "digest"
require "json"
require "time"

module Publishing
  class Client
    # Serializes revalidation and withdrawal eviction within each app process.
    LOCK = Mutex.new
    MAX_AGE = 300

    def initialize(origin: Rails.configuration.x.publisher_origin,
      token: ENV["PUBLISHER_TOKEN"].presence || Rails.application.credentials.dig(:legion_post_tools, :website_token),
      cache: Rails.cache, transport: Transport.new, clock: -> { Time.now.to_f })
      @origin = origin.delete_suffix("/")
      uri = URI.parse(@origin)
      unless uri.is_a?(URI::HTTPS) && uri.host.present? && uri.userinfo.nil? && uri.query.nil? && uri.fragment.nil? && uri.path.empty?
        raise ArgumentError, "PUBLISHER_ORIGIN must be an HTTPS origin without a path or credentials"
      end
      @cache, @transport, @clock = cache, transport, clock
      @token = token.to_s
      @deadlines = []
      @prefix = "publishing:#{Digest::SHA256.hexdigest([ @origin, @token ].join("\0"))}:"
      @contract = Contract.new(origin: @origin)
    end

    def featured
      fetch("/public/v1/featured_members", kind: :featured).fetch("members")
    end

    def story(id)
      fetch("/public/v1/member_stories/#{ERB::Util.url_encode(id)}", kind: :story, id: id).fetch("member")
    end

    def events(from:, to:)
      raise ArgumentError, "Interval must span 1–93 days" unless (1..93).cover?((to - from).to_i)
      fetch("/public/v1/events?#{URI.encode_www_form(from: from.iso8601, to: to.iso8601)}", kind: :events, from: from, to: to)
    end

    def event(id)
      fetch("/public/v1/events/#{ERB::Util.url_encode(id)}", kind: :event, id: id)
    end

    def portrait(id:, revision:, size:)
      unless [ id, revision ].all? { |value| value.is_a?(String) && value.match?(/\A[A-Za-z0-9_-]+\z/) } && %w[small large].include?(size)
        raise NotFound
      end

      fetch("/public/v1/member_stories/#{id}/portrait/#{revision}/#{size}.webp", kind: :portrait)
    end

    def expired?
      @access_denied || @deadlines.any? { |deadline| deadline <= @clock.call }
    end

    private

    def fetch(path, **validation)
      raise Unavailable, "Website token missing or malformed" unless @token.match?(/\A[!-~]+\z/)

      key = @prefix + path
      LOCK.synchronize do
        cached = @cache.read(key)
        if cached && cached[:fresh_until] > @clock.call
          @deadlines << cached[:fresh_until]
          return cached[:data]
        end
        raise Unavailable, "Publisher temporarily unavailable" if @cache.read(key + ":failure").to_f > @clock.call

        begin
          refresh(path, key, cached, validation)
        rescue Unavailable => error
          @cache.write(key + ":failure", @clock.call + 10, expires_in: 10.seconds)
          Rails.logger.warn("Publishing feed unavailable (#{error.message})")
          raise
        end
      end
    end

    def refresh(path, key, cached, validation)
      headers = { "Accept" => validation[:kind] == :portrait ? "image/webp" : "application/json",
        "Authorization" => "Bearer #{@token}", "Cache-Control" => "no-cache" }
      headers["If-None-Match"] = cached[:headers]["etag"] if cached && cached[:headers]["etag"].present?
      sent = @clock.call
      response = @transport.call(URI.parse(@origin + path), headers)
      received = @clock.call
      if response.status == 401
        @cache.delete_matched(/\A#{Regexp.escape(@prefix)}/)
        @access_denied = true
        raise Unavailable, "Website authentication rejected"
      end
      if response.status == 404 && %i[story event portrait].include?(validation[:kind])
        # Clearing collections too prevents a known withdrawal being reused here.
        @cache.delete_matched(/\A#{Regexp.escape(@prefix)}/)
        raise NotFound
      end
      if response.status == 304
        raise Unavailable, "Unmatched conditional response" unless cached && headers["If-None-Match"]
        raise Unavailable, "Missing validation date" unless response.headers["date"]
        metadata = cached[:headers].except("age").merge(response.headers)
        data = cached[:data]
      elsif response.status == 200
        data = validated_body(response, validation)
        metadata = response.headers
      else
        raise Unavailable, "HTTP #{response.status}"
      end
      lifetime = remaining_lifetime(metadata, sent, received)
      raise Unavailable, "Response already expired" unless lifetime.positive?
      @deadlines << received + lifetime
      @cache.write(key, { data: data, headers: metadata, fresh_until: received + lifetime }, expires_in: 1.day)
      data
    rescue JSON::ParserError, ArgumentError
      raise Unavailable, "Invalid publisher metadata or JSON"
    end

    def validated_body(response, validation)
      content_type = response.headers["content-type"].to_s.split(";").first
      if validation[:kind] == :portrait
        body = response.body
        unless content_type == "image/webp" && body.bytesize >= 12 && body.byteslice(0, 4) == "RIFF" &&
          body.byteslice(8, 4) == "WEBP" && body.byteslice(4, 4).unpack1("V") == body.bytesize - 8
          raise Unavailable, "Invalid publisher portrait"
        end
        body
      else
        raise Unavailable, "Unexpected content type" unless content_type == "application/json"
        @contract.validate!(JSON.parse(response.body), **validation)
      end
    end

    def remaining_lifetime(headers, sent, received)
      directives = headers.fetch("cache-control", "").split(",").map(&:strip)
      if directives.any? { |value| %w[no-store no-cache public].include?(value.downcase) } || !directives.any? { |value| value.casecmp?("private") }
        raise Unavailable, "Expected private publishing cache policy"
      end
      max_age = directives.filter_map { |value| value[/\Amax-age=(\d+)\z/i, 1] }
      raise Unavailable, "Missing or ambiguous max-age" unless max_age.one?
      date = Time.httpdate(headers.fetch("date")).to_f
      age = Integer(headers.fetch("age", "0"), 10)
      raise Unavailable, "Invalid age" if age.negative?
      corrected_age = [ [ received - date, 0 ].max, age + [ received - sent, 0 ].max ].max
      [ max_age.first.to_i, MAX_AGE ].min - corrected_age
    rescue KeyError
      raise Unavailable, "Missing publisher date"
    end
  end
end
