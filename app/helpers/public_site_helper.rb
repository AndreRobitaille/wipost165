module PublicSiteHelper
  PAGE_TITLES = {
    "home" => "In good company", "events" => "Events", "visit" => "Your first visit",
    "about" => "Still serving, together", "contact" => "Say hello",
    "membership" => "Membership", "help" => "Veteran help"
  }.freeze

  def public_page_title
    @profile&.name || @event&.title || PAGE_TITLES.fetch(action_name, "Post 165")
  end

  def person_context
    @remembered_person ? { person: @remembered_person.slug } : {}
  end

  def table_navigation
    case action_name
    when "home", "person", "about" then :people
    when "events", "event" then :events
    when "visit", "contact" then :visit
    end
  end

  def public_contact_email
    value = Rails.configuration.x.public_contact_email.to_s
    value if value.match?(URI::MailTo::EMAIL_REGEXP) && !value.match?(/[\r\n]/)
  end

  def public_contact_phone
    Rails.configuration.x.public_contact_phone.presence
  end

  def public_phone_href
    "tel:#{public_contact_phone.to_s.gsub(/[^+0-9]/, '')}"
  end

  def first_visit_subject
    @remembered_person ? "First visit to Post 165 — meeting #{@remembered_person.name}" : "First visit to Post 165"
  end

  def event_time(event)
    if event.all_day?
      label = event.starts_on.strftime("%A, %B %-d, %Y")
      if event.ends_on_exclusive && event.ends_on_exclusive > event.starts_on + 1
        label += " – #{(event.ends_on_exclusive - 1).strftime('%B %-d, %Y')}"
      end
      return "#{label} · All day"
    end
    return "Date and time to be confirmed" unless event.starts_at

    event.starts_at.strftime("%A, %B %-d, %Y · %-I:%M %p %Z")
  end
end
