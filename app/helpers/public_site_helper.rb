module PublicSiteHelper
  PUBLIC_ORIGIN = "https://wipost165.org".freeze
  # Harbor column is full width until the two-column welcome, then 52% of the 1440px page.
  HARBOR_SIZES = "(max-width: 900px) 100vw, (max-width: 1440px) 52vw, 749px".freeze
  HARBOR_SOURCES = [
    [ "two-rivers-harbor-illustration-480.webp", "480w" ],
    [ "two-rivers-harbor-illustration-768.webp", "768w" ],
    [ "two-rivers-harbor-illustration-1024.webp", "1024w" ],
    [ "two-rivers-harbor-illustration.webp", "1536w" ]
  ].freeze
  DOCUMENT_TITLE = "American Legion Post 165, Two Rivers".freeze
  # Static public pages. Event and person URLs follow the publisher feed.
  SITEMAP_PATHS = %w[/ /why-the-legion /events /visit /about /contact /membership /veteran-help].freeze
  PAGE_HEADINGS = {
    "events" => "Events", "visit" => "Visit Us", "about" => "About the Post",
    "contact" => "Contact", "membership" => "Membership", "help" => "Veteran Help", "why_legion" => "Why the Legion?"
  }.freeze
  # Page copy with the on-page headline removed. Shared templates use the V1 wording.
  PAGE_DESCRIPTIONS = {
    "v1" => {
      "why_legion" => "Some conversations start a little easier when you’ve both served. Where they go from there is the good part.",
      "home" => "Military service is our common bond. Fellowship, mutual helpfulness, and service to our community keep that bond alive.",
      "events" => "Public occasions over the next three months. Find a date and make a plan. Your first time here? A public event is a good way to get to know us.",
      "visit" => "Start with a public event—it’s a good way to get to know us. We meet the first Tuesday of each month at 6:30 p.m. at the Manitowoc Rifle & Pistol Club.",
      "about" => "Military service is our common bond. Fellowship, mutual helpfulness, and service to our community keep that bond alive.",
      "contact" => "Questions about a first visit, membership, or getting involved? Mailing address: American Legion Post 165, PO Box 11, Two Rivers, WI 54241.",
      "membership" => "Interested in joining? Learn who’s eligible for the American Legion and how membership works at Post 165 in Two Rivers.",
      "help" => "For questions about veterans benefits, start with the Manitowoc County Veteran Services Office. The Post’s contact channels are not emergency services."
    },
    "v2" => {
      "events" => "Public occasions over the next three months. Plan your first visit.",
      "visit" => "Start with a public event—it’s a good way to get to know us. Regular Post meetings are on the first Tuesday of each month at 6:30 p.m.",
      "contact" => "Questions about coming along, membership, or the Post? Start here. Mailing address: American Legion Post 165, PO Box 11, Two Rivers, WI 54241."
    }
  }.freeze
  COMING_SOON_DESCRIPTION = "Website coming soon. Robert E. Burns American Legion Post 165, Two Rivers, Wisconsin. We’re preparing our new website. Please check back soon.".freeze
  V2_HOME_WITH_PEOPLE = "Veterans. Neighbors. Good company. A few faces to know before you walk in. Meet someone, or see what’s coming up.".freeze
  V2_HOME_WITHOUT_PEOPLE = "Get to know your local American Legion Post. Plan a first visit, or see what’s coming up.".freeze

  def public_document_title
    heading = public_page_heading
    return DOCUMENT_TITLE if heading.blank?

    "#{heading} – #{DOCUMENT_TITLE}"
  end

  def public_page_description
    return COMING_SOON_DESCRIPTION if Rails.configuration.x.public_site_coming_soon
    return not_found_description if @page_error == :not_found
    return unavailable_description if @page_error == :unavailable
    return v2_home_description if !public_site_v1? && action_name == "home"
    return @profile.introduction.to_s.squish.truncate(150) if @profile
    return event_meta_description if @event

    edition = public_site_v1? ? "v1" : "v2"
    PAGE_DESCRIPTIONS.dig(edition, action_name) || PAGE_DESCRIPTIONS.dig("v1", action_name)
  end

  def public_canonical_url
    path = case action_name
    when "person" then @profile ? person_path(@profile) : request.path
    when "event" then @event ? event_path(@event) : request.path
    else request.path
    end
    "#{PUBLIC_ORIGIN}#{path}"
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

  def harbor_illustration_srcset
    HARBOR_SOURCES.map { |name, width| "#{asset_path(name)} #{width}" }.join(", ")
  end

  def launch_harbor_page?
    public_site_v1? && action_name == "home" && @page_error.nil?
  end

  # Home and the practical pages only need the launch sheet. Interior pages add their own.
  def launch_stylesheets
    sheets = %w[launch]
    sheets << "post_pages" if %w[about membership help].include?(action_name)
    sheets << "why_legion" if action_name == "why_legion"
    sheets
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

  def public_page_heading
    return "Website coming soon" if Rails.configuration.x.public_site_coming_soon
    return "That page isn’t here" if @page_error == :not_found
    return "Please check back shortly" if @page_error == :unavailable
    return if action_name == "home"
    return "Meet #{@profile.name}" if @profile
    return @event.title if @event

    PAGE_HEADINGS.fetch(action_name)
  end

  def v2_home_description
    @people&.any? ? V2_HOME_WITH_PEOPLE : V2_HOME_WITHOUT_PEOPLE
  end

  def not_found_description
    if public_site_v1?
      "That page isn’t here. Visit the public calendar or contact the Post for current information."
    else
      "That page isn’t here. The introduction or event may no longer be available."
    end
  end

  def unavailable_description
    if public_site_v1?
      "Please check back shortly. We can’t load this event right now."
    else
      "Please check back shortly. We can’t load this introduction or event right now."
    end
  end

  def event_meta_description
    parts = []
    parts << "This event has been cancelled." if @event.cancelled?
    parts << "This event has already taken place." if !@event.cancelled? && @event.past?
    parts << @event.description.to_s.squish if @event.description.present?
    parts << event_time(@event)
    parts << @event.location_name if @event.location_name.present?
    parts << "Please check with the Post before making plans."
    parts.join(" ").squish.truncate(150)
  end

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
