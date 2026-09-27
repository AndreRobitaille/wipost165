module PublishingHelpers
  def fixture(name)
    JSON.parse(Rails.root.join("test/fixtures/publishing/#{name}.json").read)
  end

  def publisher_response(data = nil, status: 200, headers: {})
    Publishing::Response.new(status: status, body: data ? JSON.generate(data) : "",
      headers: { "content-type" => "application/json", "date" => Time.at(@now).httpdate,
        "cache-control" => "public, max-age=300, must-revalidate", "etag" => '"revision-1"' }.merge(headers))
  end

  def build_client
    @now = Time.utc(2026, 9, 27, 14).to_f
    @replies = []
    @requests = []
    @transport = lambda do |uri, headers|
      @requests << [ uri, headers ]
      result = @replies.shift || raise("Unexpected HTTP request: #{uri}")
      raise result if result.is_a?(Exception)
      result
    end
    @cache = ActiveSupport::Cache::MemoryStore.new
    @client = Publishing::Client.new(cache: @cache, transport: @transport, clock: -> { @now })
  end
end
