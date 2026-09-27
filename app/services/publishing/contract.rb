require "uri"

module Publishing
  class Contract
    def initialize(origin:)
      @origin = origin
    end

    def validate!(data, kind:, id: nil, from: nil, to: nil)
      check(data.is_a?(Hash) && data["schema_version"] == 1)
      case kind
      when :featured
        check(data["complete"] == true && data["members"].is_a?(Array) && data["members"].size <= 3)
        data["members"].each { |member| story!(member) }
        distinct!(data["members"])
      when :story
        story!(data["member"])
        check(data["member"]["id"] == id)
      when :events
        zone!(data["timezone"])
        check(data["complete"] == true && data["from"] == from.to_s && data["to"] == to.to_s && data["events"].is_a?(Array))
        data["events"].each { |event| event!(event) }
        distinct!(data["events"])
        interval!(data, from, to)
      when :event
        zone!(data["timezone"])
        event!(data["event"])
        check(data["event"]["id"] == id)
      end
      data
    rescue ArgumentError, TypeError, KeyError, TZInfo::InvalidTimezoneIdentifier
      raise Unavailable, "Invalid publishing response"
    end

    private

    def check(condition)
      raise Unavailable, "Invalid publishing response" unless condition
    end

    def string!(value, nullable: false)
      return if nullable && value.nil?
      check(value.is_a?(String) && value.valid_encoding? && value.present?)
    end

    def timestamp!(value)
      check(value.is_a?(String) && value.match?(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})\z/))
      Time.iso8601(value)
    end

    def date!(value)
      check(value.is_a?(String) && value.match?(/\A\d{4}-\d{2}-\d{2}\z/))
      Date.iso8601(value)
    end

    def zone!(value)
      string!(value)
      TZInfo::Timezone.get(value)
    end

    def distinct!(records)
      check(records.map { |record| record["id"] }.uniq.size == records.size)
    end

    def story!(member)
      check(member.is_a?(Hash))
      %w[id display_name introduction story].each { |field| string!(member.fetch(field)) }
      string!(member.fetch("conversation_starter"), nullable: true)
      timestamp!(member.fetch("updated_at"))
      portrait = member.fetch("portrait")
      check(portrait.is_a?(Hash))
      %w[revision alt].each { |field| string!(portrait.fetch(field)) }
      variants = portrait.fetch("variants")
      check(variants.is_a?(Array) && variants.size == 2 && variants.all? { |variant| variant.is_a?(Hash) })
      check(variants.map { |variant| variant["size"] }.sort == %w[large small])
      variants.each do |variant|
        width, height = variant["size"] == "small" ? [ 320, 400 ] : [ 640, 800 ]
        check(variant["width"] == width && variant["height"] == height && variant["content_type"] == "image/webp")
        path = "/public/v1/member_stories/#{ERB::Util.url_encode(member['id'])}/portrait/#{ERB::Util.url_encode(portrait['revision'])}/#{variant['size']}.webp"
        check(variant["url"] == "#{@origin}#{path}")
      end
    end

    def interval!(data, from, to)
      zone = Time.find_zone!(data.fetch("timezone"))
      lower = zone.local(from.year, from.month, from.day)
      upper = zone.local(to.year, to.month, to.day)
      ordered = data["events"].map do |event|
        if event["all_day"]
          start_date = Date.iso8601(event["starts_on"])
          finish = event["ends_on_exclusive"] ? Date.iso8601(event["ends_on_exclusive"]) : start_date + 1
          check(start_date < to && finish > from)
          start = zone.local(start_date.year, start_date.month, start_date.day)
        else
          start = Time.iso8601(event["starts_at"])
          finish = event["ends_at"] ? Time.iso8601(event["ends_at"]) : start
          check(start < upper && (finish > start ? finish > lower : start >= lower))
        end
        [ start.to_f, event["id"] ]
      end
      check(ordered == ordered.sort)
    end

    def event!(event)
      check(event.is_a?(Hash))
      %w[id title].each { |field| string!(event.fetch(field)) }
      %w[description location].each { |field| string!(event.fetch(field), nullable: true) }
      check([ true, false ].include?(event.fetch("all_day")) && [ true, false ].include?(event.fetch("cancelled")))
      check(event.fetch("category") == "public_event")
      timestamp!(event.fetch("updated_at"))
      if event["all_day"]
        check(event.fetch("starts_at").nil? && event.fetch("ends_at").nil?)
        start_date = date!(event.fetch("starts_on"))
        finish = event.fetch("ends_on_exclusive")
        check(finish.nil? || date!(finish) > start_date)
      else
        check(event.fetch("starts_on").nil? && event.fetch("ends_on_exclusive").nil?)
        start_time = timestamp!(event.fetch("starts_at"))
        finish = event.fetch("ends_at")
        check(finish.nil? || timestamp!(finish) >= start_time)
      end
    end
  end
end
