class PublicContent
  attr_reader :people_unavailable, :events_unavailable

  def initialize(preview: false, client: nil)
    @preview = preview
    @client = client || Publishing::Client.new
  end

  def expired? = !@preview && @client.expired?

  def people
    @people ||= @preview ? PreviewContent.people : @client.featured.map { |record| PublicPerson.new(record) }
  rescue Publishing::Unavailable
    @people_unavailable = true
    @people = []
  end

  def find_person(id)
    return if id.blank?
    return PreviewContent.people.find { |person| person.slug == id } if @preview

    PublicPerson.new(@client.story(id))
  rescue Publishing::NotFound
    @people&.reject! { |person| person.slug == id }
    nil
  end

  def events
    return PreviewContent.events if @preview

    # The Post's site uses its configured local date; the feed supplies event timezone.
    data = @client.events(from: Date.current, to: Date.current + 90)
    data.fetch("events").map { |record| PublicOccasion.new(record, timezone: data.fetch("timezone")) }
  rescue Publishing::Unavailable
    @events_unavailable = true
    []
  end

  def find_event!(id)
    if @preview
      return PreviewContent.events.find { |event| event.slug == id } || raise(Publishing::NotFound)
    end

    data = @client.event(id)
    PublicOccasion.new(data.fetch("event"), timezone: data.fetch("timezone"))
  end
end
