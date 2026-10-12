module PublicSiteHelper
  PUBLIC_ORIGIN = "https://wipost165.org".freeze
  # Static public pages. Event and person URLs follow the publisher feed.
  SITEMAP_PATHS = %w[/ /events /visit /about /contact /membership /veteran-help].freeze
  SITE_NAME = "American Legion Post 165 · Two Rivers".freeze
  SITE_DESCRIPTION = "Get to know Robert E. Burns American Legion Post 165 in Two Rivers, Wisconsin. Find an occasion, plan a first visit, or contact the Post.".freeze
  PAGE_TITLES = {
    "home" => "In good company", "events" => "Events", "visit" => "Your first visit",
    "about" => "Still serving, together", "contact" => "Say hello",
    "membership" => "Membership", "help" => "Veteran help"
  }.freeze

  PAGE_DESCRIPTIONS = {
    "events" => "Find upcoming public events at American Legion Post 165 in Two Rivers, with dates, locations, and cancellation updates.",
    "visit" => "Plan your first visit to Post 165 in Two Rivers. Find meeting and arrival information, parking details, and ways to get in touch.",
    "about" => "Learn about Robert E. Burns American Legion Post 165 in Two Rivers: fellowship, mutual helpfulness, and service to the community.",
    "contact" => "Contact American Legion Post 165 in Two Rivers by email or phone, or find the Post's mailing address.",
    "membership" => "Interested in joining Post 165? Find American Legion membership information and contact the Post with local questions.",
    "help" => "Find the Manitowoc County Veteran Services Office for benefits questions and ways to contact Post 165."
  }.freeze

  def public_page_title
    return "Page not found" if @page_error == :not_found
    return "Temporarily unavailable" if @page_error == :unavailable || public_content_unavailable?
    return "Website coming soon" if Rails.configuration.x.public_site_coming_soon
    return "Website in preparation" unless public_page_indexable?
    return "Cancelled: #{@event.title}" if @event&.cancelled?
    return "Still serving, in good company" if public_site_v1? && action_name == "home"

    @profile&.name || @event&.title || PAGE_TITLES.fetch(action_name, "Post 165")
  end

  def public_page_description
    return "This page is no longer available. Visit Post 165's website for current information." if @page_error == :not_found
    return "This page is temporarily unavailable. Please try again shortly." if @page_error == :unavailable || public_content_unavailable?
    return SITE_DESCRIPTION unless public_page_indexable?
    return @profile.introduction.squish.truncate(200) if @profile
    if @event
      details = [ ("Cancelled." if @event.cancelled?), event_time(@event), @event.location_name, @event.description ]
      return details.compact.join(" · ").squish.truncate(200)
    end
    if action_name == "contact" && !public_contact_available?
      return "Find the mailing address and first-visit information for American Legion Post 165 in Two Rivers."
    end

    PAGE_DESCRIPTIONS.fetch(action_name, SITE_DESCRIPTION)
  end

  def public_canonical_url
    return unless public_page_indexable?

    path = case action_name
    when "person" then person_path(@profile)
    when "event" then event_path(@event)
    else request.path
    end
    PUBLIC_ORIGIN + path
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

  def public_contact_available?
    public_contact_email.present? || public_contact_phone.present?
  end

  def public_phone_href
    "tel:#{public_contact_phone.to_s.gsub(/[^+0-9]/, '')}"
  end

  # gtag config records the first full load. Later Turbo visits send their own page_view.
  def public_google_tag
    id = Rails.configuration.x.ga4_measurement_id.to_s.strip
    return unless id.match?(PublicSiteEnv::GA4_MEASUREMENT_ID)

    nonce = content_security_policy_nonce.presence
    loader = { src: "https://www.googletagmanager.com/gtag/js?id=#{id}", async: true, fetchpriority: "low" }
    loader[:nonce] = nonce if nonce
    script_options = {}
    script_options[:nonce] = true if nonce
    safe_join([ tag.script(**loader), javascript_tag(google_tag_script(id), script_options) ])
  end

  def self.sitemap_paths
    # Coming soon serves one holding page at every public route.
    return %w[/] if Rails.configuration.x.public_site_coming_soon

    SITEMAP_PATHS
  end

  def self.robots_txt
    <<~TEXT
      # Allow crawlers to read each page's noindex directive during preparation.
      # This file is not access control; the coming-soon setting controls public exposure.
      User-agent: *
      Disallow:

      Sitemap: #{PUBLIC_ORIGIN}/sitemap.xml
    TEXT
  end

  def self.sitemap_xml
    entries = sitemap_paths.map { |path| "  <url><loc>#{ERB::Util.html_escape("#{PUBLIC_ORIGIN}#{path}")}</loc></url>" }
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      #{entries.join("\n")}
      </urlset>
    XML
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

  private

  def google_tag_script(id)
    <<~JS
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', #{id.to_json});
      document.addEventListener("turbo:load", function() {
        if (!window.gtag) return;
        if (!window.__ga4SawInitialLoad) {
          window.__ga4SawInitialLoad = true;
          return;
        }
        gtag("event", "page_view", { page_location: window.location.href, page_title: document.title });
      });
    JS
  end
end
