# Plain-text and XML descriptions of the public site, built from published
# facts and the event feed.
class PublicDiscovery
  ORGANIZATION_ID = "#{PublicSiteHelper::PUBLIC_ORIGIN}/#organization".freeze
  ORIGIN = PublicSiteHelper::PUBLIC_ORIGIN
  FETCH = Object.new.freeze
  # Full words that mean the same street as the meeting place's abbreviations.
  STREET_SUFFIXES = {
    "avenue" => "ave",
    "boulevard" => "blvd",
    "court" => "ct",
    "drive" => "dr",
    "lane" => "ln",
    "place" => "pl",
    "road" => "rd",
    "street" => "st"
  }.freeze
  LOCATION_TAIL = /\A(?<prefix>.+),\s*(?<locality>[A-Za-z][A-Za-z .'-]*),\s*(?<region>[A-Z]{2})\s+(?<postal>\d{5}(?:-\d{4})?)\s*\z/
  private_constant :STREET_SUFFIXES, :LOCATION_TAIL

  def self.llms_txt(events: FETCH)
    records = upcoming_events(events)
    lines = [
      "# #{PublicPost::NAME}",
      "",
      "> #{ORIGIN} is the official site of #{PublicPost::NAME}, #{PublicPost::LOCALITY}. The previous domain #{PublicPost::PREVIOUS_DOMAIN} forwards here.",
      "",
      "## Meetings",
      "",
      "- [Regular Post meetings](#{ORIGIN}/visit): #{PublicPost.meeting_summary}",
      "",
      "## Membership",
      "",
      "- [How to join this Post](#{ORIGIN}/membership)",
      "",
      "## Contact",
      ""
    ]
    email = PublicPost.email
    lines << "- Email: #{email}" if email
    lines << "- Mail: #{PublicPost.mailing_summary}"
    lines << "- [Contact the Post](#{ORIGIN}/contact)"
    lines += [
      "",
      "## Veteran help",
      "",
      "- [Service Officer](#{ORIGIN}/veteran-help)",
      "",
      "## Events",
      "",
      "- [Public events](#{ORIGIN}/events)"
    ]
    records.each do |event|
      lines << "- [#{link_label(event.title)}](#{ORIGIN}#{event_path(event)}): #{schedule_label(event)}"
    end
    lines += [
      "",
      "## Facebook",
      "",
      "- [Facebook](#{PublicPost::FACEBOOK_URL})",
      ""
    ]
    lines.join("\n")
  end

  def self.sitemap_xml(events: FETCH)
    records = published_events(events)
    entries = sitemap_pages + sitemap_events(records)
    body = entries.map { |entry| url_element(entry) }.join("\n")
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      #{body}
      </urlset>
    XML
  end

  def self.website_schema
    {
      "@context" => "https://schema.org",
      "@type" => "WebSite",
      "name" => PublicSiteHelper::DOCUMENT_TITLE,
      "alternateName" => [ "Robert E. Burns American Legion Post 165", "wipost165.org" ],
      "url" => "#{ORIGIN}/",
      "publisher" => { "@id" => ORGANIZATION_ID }
    }
  end

  def self.organization_schema
    data = {
      "@context" => "https://schema.org",
      "@type" => "Organization",
      "@id" => ORGANIZATION_ID,
      "name" => PublicPost::NAME,
      "alternateName" => PublicSiteHelper::DOCUMENT_TITLE,
      "url" => "#{ORIGIN}/",
      "address" => PublicPost.mailing_address,
      "location" => PublicPost.meeting_place,
      "parentOrganization" => {
        "@type" => "Organization",
        "name" => PublicPost::PARENT_NAME,
        "url" => PublicPost::PARENT_URL
      },
      "sameAs" => [ PublicPost::FACEBOOK_URL ]
    }
    email = PublicPost.email
    data["email"] = email if email
    data
  end

  def self.event_schema?(event)
    event && !event.cancelled? && !PublicPost.withheld_event?(event) && event.start_date_iso.present?
  end

  def self.event_schema(event, url:)
    data = {
      "@context" => "https://schema.org",
      "@type" => "Event",
      "name" => event.title,
      "startDate" => event.start_date_iso,
      "eventStatus" => "https://schema.org/EventScheduled",
      "eventAttendanceMode" => "https://schema.org/OfflineEventAttendanceMode",
      "organizer" => { "@id" => ORGANIZATION_ID },
      "url" => url
    }
    end_date = event.end_date_iso
    data["endDate"] = end_date if end_date
    description = event.description.to_s.squish
    data["description"] = description if description.present?
    place = place_for(event.location_name)
    data["location"] = place if place
    data
  end

  # Home events use the Organization block's meeting place, so the venue name
  # and postal address cannot drift. Any other location is a PostalAddress only
  # when it already contains a venue name, a numbered street, and city, state,
  # and ZIP. Otherwise the name is one line and the address is omitted.
  def self.place_for(name)
    text = name.to_s.strip
    return if text.empty?
    return PublicPost.meeting_place if home_venue?(text)

    place_from_location(text) || { "@type" => "Place", "name" => text.squish }
  end

  def self.home_venue?(text)
    key = venue_key(text)
    key.present? && home_venue_keys.include?(key)
  end

  def self.home_venue_keys
    place = PublicPost.meeting_place
    address = place.fetch("address")
    line = [
      address.fetch("streetAddress"),
      address.fetch("addressLocality"),
      "#{address.fetch("addressRegion")} #{address.fetch("postalCode")}"
    ].join(", ")
    name = place.fetch("name")
    [ name, line, "#{name}, #{line}" ].map { |form| venue_key(form) }
  end

  def self.venue_key(text)
    pattern = /\b(?:#{STREET_SUFFIXES.keys.join("|")})\b/
    text.to_s.downcase
      .gsub("&", " and ")
      .gsub(/\b(\d{5})-\d{4}\b/, "\\1")
      .gsub(pattern, STREET_SUFFIXES)
      .gsub(/[^a-z0-9]+/, " ")
      .squish
  end

  def self.place_from_location(text)
    match = text.gsub(/\s*[\r\n]+\s*/, ", ").match(LOCATION_TAIL)
    return unless match

    parts = match[:prefix].split(",").map(&:strip).compact_blank
    street = parts.last
    return unless parts.size > 1 && street_line?(street)

    name = parts[0..-2].join(", ").squish
    return if name.empty?

    {
      "@type" => "Place",
      "name" => name,
      "address" => PublicPost.postal_address(street, match[:locality].squish, match[:region], match[:postal])
    }
  end

  def self.street_line?(text)
    text.match?(/\A\d/) && text.match?(/[A-Za-z]/)
  end
  private_class_method :home_venue?, :home_venue_keys, :venue_key, :place_from_location, :street_line?

  def self.published_events(events)
    records = events.equal?(FETCH) ? feed_events : events
    Array(records).reject { |event| PublicPost.withheld_event?(event) }
  end

  def self.upcoming_events(events)
    published_events(events).select { |event| event.upcoming? && event.updated_at }
  end

  def self.feed_events
    return [] if Rails.configuration.x.public_site_coming_soon

    PublicContent.new(preview: Rails.configuration.x.public_site_preview).events
  rescue Publishing::Unavailable
    []
  end
  private_class_method :feed_events

  def self.sitemap_pages
    if Rails.configuration.x.public_site_coming_soon
      return [ { loc: "#{ORIGIN}/", lastmod: PublicPageRevisions.at("coming_soon") } ]
    end

    edition = Rails.configuration.x.public_site_edition
    PublicSiteHelper::SITEMAP_PATHS.map do |path|
      { loc: "#{ORIGIN}#{path}", lastmod: PublicPageRevisions.at(edition, path) }
    end
  end
  private_class_method :sitemap_pages

  def self.sitemap_events(events)
    events.select { |event| event.upcoming? && event.updated_at }.map do |event|
      { loc: "#{ORIGIN}#{event_path(event)}", lastmod: event.updated_at }
    end
  end
  private_class_method :sitemap_events

  def self.url_element(entry)
    loc = ERB::Util.html_escape(entry.fetch(:loc))
    lastmod = sitemap_timestamp(entry.fetch(:lastmod))
    "  <url><loc>#{loc}</loc><lastmod>#{lastmod}</lastmod></url>"
  end
  private_class_method :url_element

  def self.sitemap_timestamp(value)
    value.is_a?(Date) ? value.iso8601 : value.utc.iso8601
  end
  private_class_method :sitemap_timestamp

  def self.event_path(event)
    "/events/#{ERB::Util.url_encode(event.slug)}"
  end
  private_class_method :event_path

  def self.link_label(text)
    text.to_s.gsub(/[\r\n\t]+/, " ").gsub(/[\[\]]/, "").squish
  end
  private_class_method :link_label

  def self.schedule_label(event)
    if event.all_day?
      label = event.starts_on.strftime("%A, %B %-d, %Y")
      "#{label} (all day)"
    elsif event.starts_at
      event.starts_at.strftime("%A, %B %-d, %Y, %-I:%M %p %Z")
    else
      "Date to be confirmed"
    end
  end
  private_class_method :schedule_label
end
