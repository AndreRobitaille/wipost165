class EventCalendar
  def initialize(event, url:)
    @event = event
    @url = url
  end

  def google_query
    {
      action: "TEMPLATE", text: @event.title, details: details,
      location: @event.location_name, dates: "#{start_value.value_ical}/#{(end_value || start_value).value_ical}",
      stz: @event.timezone, etz: @event.timezone
    }.compact.to_query
  end

  def to_ical
    calendar = Icalendar::Calendar.new
    calendar.prodid = "-//American Legion Post 165//Public Calendar//EN"
    calendar.event do |entry|
      entry.uid = @url
      entry.dtstamp = utc_value(@event.updated_at)
      entry.dtstart = start_value
      entry.dtend = end_value if end_value
      entry.summary = calendar_text(@event.title)
      entry.location = calendar_text(@event.location_name) if @event.location_name.present?
      entry.url = @url
      entry.description = details
    end
    calendar.to_ical
  end

  private

  def details
    return @url if @event.all_day? || @event.ends_at

    "End time not specified.\n#{@url}"
  end

  def start_value
    @event.all_day? ? Icalendar::Values::Date.new(@event.starts_on) : utc_value(@event.starts_at)
  end

  def end_value
    if @event.all_day?
      Icalendar::Values::Date.new(@event.ends_on_exclusive || @event.starts_on.next_day)
    elsif @event.ends_at && @event.ends_at > @event.starts_at
      utc_value(@event.ends_at)
    end
  end

  def utc_value(time)
    Icalendar::Values::DateTime.new(time.utc, "tzid" => "UTC")
  end

  def calendar_text(value)
    # The gem accepts iCalendar-escaped input. Preserve literal backslashes from the publisher.
    value.gsub("\\") { "\\\\" }.gsub(/\r\n?/, "\n").delete("\x00-\x08\x0B\x0C\x0E-\x1F\x7F")
  end
end
