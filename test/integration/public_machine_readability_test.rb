require "test_helper"
require "minitest/mock"
require_relative "../support/publishing_helpers"

class PublicMachineReadabilityTest < ActionDispatch::IntegrationTest
  include PublishingHelpers

  ORIGIN = PublicSiteHelper::PUBLIC_ORIGIN
  ORGANIZATION_ID = "#{ORIGIN}/#organization"
  GUESTS_LINE = "Please check with the Post before making plans."

  setup do
    build_client
    @settings = %i[
      public_site_edition public_site_preview public_site_coming_soon public_site_launch_ready
      public_contact_email public_contact_phone
    ].to_h { |key| [ key, Rails.configuration.x.public_send(key) ] }
    Rails.configuration.x.public_site_edition = "v1"
    Rails.configuration.x.public_site_preview = false
    Rails.configuration.x.public_site_coming_soon = false
    Rails.configuration.x.public_site_launch_ready = true
  end

  teardown do
    @settings.each { |key, value| Rails.configuration.x.public_send("#{key}=", value) }
  end

  def using_feed(&block)
    constructor = Publishing::Client.method(:new)
    factory = -> { constructor.call(token: "website-test-token", cache: @cache, transport: @transport, clock: -> { @now }) }
    Publishing::Client.stub(:new, factory, &block)
  end

  def event_collection(events)
    fixture("events").merge("from" => Date.current.iso8601, "to" => (Date.current + 90).iso8601, "events" => events)
  end

  def detail(event)
    { "schema_version" => 1, "timezone" => "America/Chicago", "event" => event }
  end

  def base_event
    fixture("events").fetch("events").first
  end

  def json_ld_blocks
    css_select('script[type="application/ld+json"]').map { |node| JSON.parse(node.text) }
  end

  def sitemap_lastmod(path)
    response.body[%r{<loc>#{Regexp.escape("#{ORIGIN}#{path}")}</loc><lastmod>([^<]+)</lastmod>}, 1]
  end

  def assert_valid_content_date(lastmod)
    assert_match(/\A\d{4}-\d{2}-\d{2}(?:T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2}))?\z/, lastmod)
    assert_operator Date.iso8601(lastmod[0, 10]), :<=, Date.current
  end

  def refute_phone(data)
    json = JSON.generate(data)
    assert_nil data["telephone"]
    assert_not_includes json, "telephone"
    assert_not_includes json, "860-7478"
    assert_not_includes json, "920-683-4055"
  end

  test "sitemap, llms.txt, and event JSON-LD follow public events and exclude funerals" do
    cancelled = base_event.merge(
      "id" => "cancelled_public",
      "title" => "Cancelled public gathering",
      "cancelled" => true,
      "starts_at" => "2026-10-19T18:00:00-05:00",
      "ends_at" => nil,
      "updated_at" => "2026-10-02T11:00:00Z"
    )
    upcoming = base_event.merge(
      "id" => "upcoming_public",
      "title" => "Upcoming public gathering",
      "starts_at" => "2026-10-20T18:00:00-05:00",
      "ends_at" => "2026-10-20T20:00:00-05:00",
      "location" => "Manitowoc Rifle & Pistol Club, 7227 Sandy Hill Ln, Two Rivers, WI 54241",
      "updated_at" => "2026-12-01T16:30:00Z"
    )
    no_address = base_event.merge(
      "id" => "no_address_public",
      "title" => "Gathering without a street address",
      "starts_at" => "2026-10-22T18:00:00-05:00",
      "ends_at" => nil,
      "location" => nil,
      "updated_at" => "2026-10-02T12:00:00Z"
    )
    all_day = base_event.merge(
      "id" => "all_day_public",
      "title" => "All-day public gathering",
      "description" => nil,
      "location" => "Example location — not a real event",
      "all_day" => true,
      "starts_at" => nil,
      "ends_at" => nil,
      "starts_on" => "2026-12-01",
      "ends_on_exclusive" => nil,
      "updated_at" => "2026-10-04T12:00:00Z"
    )
    funeral = base_event.merge(
      "id" => "event_withheld_1",
      "title" => "Honor funeral",
      "category" => "funeral",
      "starts_at" => "2026-10-21T10:00:00-05:00",
      "ends_at" => nil,
      "updated_at" => "2026-10-02T12:00:00Z"
    )
    titled_funeral = base_event.merge(
      "id" => "event_withheld_2",
      "title" => "Military funeral honors",
      "category" => "public_event",
      "starts_at" => "2026-10-23T18:00:00-05:00",
      "ends_at" => nil,
      "updated_at" => "2026-10-02T13:00:00Z"
    )
    past = base_event.merge(
      "id" => "past_public",
      "title" => "Earlier public gathering",
      "starts_at" => "2026-10-03T18:00:00-05:00",
      "ends_at" => nil,
      "updated_at" => "2026-09-01T12:00:00Z"
    )

    travel_to Time.utc(2026, 10, 5, 16) do
      @replies << publisher_response(event_collection([ cancelled, upcoming, funeral, no_address, titled_funeral, all_day ]))
      @replies << publisher_response(detail(upcoming))
      @replies << publisher_response(detail(no_address))
      @replies << publisher_response(detail(all_day))
      @replies << publisher_response(detail(past))
      @replies << publisher_response(detail(cancelled))
      @replies << publisher_response(detail(funeral))
      @replies << publisher_response(detail(titled_funeral))
      @replies << publisher_response(fixture("featured").merge("members" => []))

      using_feed do
        get "/sitemap.xml"
        assert_response :success
        assert_equal "application/xml", response.media_type
        PublicSiteHelper::SITEMAP_PATHS.each do |path|
          assert_includes response.body, "<loc>#{ORIGIN}#{path}</loc>"
        end
        urls = response.body.scan(%r{<url>(.*?)</url>}m).flatten
        assert_equal PublicSiteHelper::SITEMAP_PATHS.size + 3, urls.size
        assert urls.all? { |url| url.include?("<lastmod>") }
        assert_includes response.body, "<loc>#{ORIGIN}/events/upcoming_public</loc>"
        assert_includes response.body, "<loc>#{ORIGIN}/events/no_address_public</loc>"
        assert_includes response.body, "<loc>#{ORIGIN}/events/all_day_public</loc>"
        assert_includes response.body, "<lastmod>2026-12-01T16:30:00Z</lastmod>"
        assert_includes response.body, "<lastmod>#{PublicPageRevisions.at("v1", "/visit").iso8601}</lastmod>"
        assert_not_includes response.body, "past_public"
        assert_not_includes response.body, "cancelled_public"
        assert_not_includes response.body, "event_withheld_1"
        assert_not_includes response.body, "event_withheld_2"
        assert_not_includes response.body, "Honor funeral"
        assert_not_includes response.body, "/people"
        assert_not_includes response.body, "2026-10-05T16:00:00Z"
        assert_match(/max-age=300/, response.headers["Cache-Control"])

        past_record = PublicOccasion.new(past, timezone: "America/Chicago")
        funeral_record = PublicOccasion.new(funeral, timezone: "America/Chicago")
        upcoming_record = PublicOccasion.new(upcoming, timezone: "America/Chicago")
        filtered = PublicDiscovery.sitemap_xml(events: [ past_record, funeral_record, upcoming_record ])
        assert_includes filtered, "#{ORIGIN}/events/upcoming_public"
        assert_not_includes filtered, "past_public"
        assert_not_includes filtered, "event_withheld_1"
        assert_not_includes filtered, "Honor funeral"

        get "/llms.txt"
        assert_response :success
        assert_equal "text/plain", response.media_type
        assert_includes response.body, "#{ORIGIN} is the official site of #{PublicPost::NAME}, #{PublicPost::LOCALITY}."
        assert_includes response.body, "#{PublicPost::PREVIOUS_DOMAIN} forwards here."
        assert_includes response.body, PublicPost.meeting_summary
        assert_includes response.body, "#{ORIGIN}/visit"
        assert_includes response.body, "#{ORIGIN}/membership"
        assert_includes response.body, "Email: #{PublicPost.email}"
        assert_includes response.body, PublicPost.mailing_summary
        assert_includes response.body, "#{ORIGIN}/contact"
        assert_includes response.body, "#{ORIGIN}/veteran-help"
        assert_includes response.body, "#{ORIGIN}/events"
        assert_includes response.body, PublicPost::FACEBOOK_URL
        assert_includes response.body, "Upcoming public gathering"
        assert_includes response.body, "Gathering without a street address"
        assert_includes response.body, "All-day public gathering"
        assert_not_includes response.body, "Honor funeral"
        assert_not_includes response.body, "Military funeral honors"
        assert_not_includes response.body, "Earlier public gathering"
        assert_not_includes response.body, "Cancelled public gathering"
        assert_not_includes response.body, "860-7478"
        assert_not_includes response.body, "920-683-4055"
        assert_not_includes response.body, GUESTS_LINE

        get event_path(upcoming.fetch("id"))
        assert_response :success
        event_ld = json_ld_blocks.find { |data| data["@type"] == "Event" }
        organization = json_ld_blocks.find { |data| data["@type"] == "Organization" }
        assert event_ld, "event page is missing Event JSON-LD"
        assert_equal upcoming.fetch("title"), event_ld["name"]
        assert_equal "2026-10-20T18:00:00-05:00", event_ld["startDate"]
        assert_equal "https://schema.org/EventScheduled", event_ld["eventStatus"]
        assert_equal "https://schema.org/OfflineEventAttendanceMode", event_ld["eventAttendanceMode"]
        assert_equal({ "@id" => ORGANIZATION_ID }, event_ld["organizer"])
        assert_equal "#{ORIGIN}/events/upcoming_public", event_ld["url"]
        assert_equal "Synthetic event for contract testing.", event_ld["description"]
        json_ld_blocks.each { |block| assert_not_includes block.to_json, GUESTS_LINE }
        blank = PublicOccasion.new(upcoming.merge("description" => " \n "), timezone: "America/Chicago")
        refute PublicDiscovery.event_schema(blank, url: "#{ORIGIN}/events/upcoming_public").key?("description")
        assert_includes response.body, GUESTS_LINE
        assert_equal "Place", event_ld.dig("location", "@type")
        assert_equal upcoming.fetch("location"), event_ld.dig("location", "name")
        assert_equal "7227 Sandy Hill Ln", event_ld.dig("location", "address", "streetAddress")
        assert_equal "Two Rivers", event_ld.dig("location", "address", "addressLocality")
        assert_equal "WI", event_ld.dig("location", "address", "addressRegion")
        assert_equal "54241", event_ld.dig("location", "address", "postalCode")
        assert_nil event_ld.dig("location", "address", "addressCountry")
        refute_phone(event_ld)
        assert_equal ORGANIZATION_ID, organization["@id"]
        assert_equal PublicPost::NAME, organization["name"]
        assert_equal PublicSiteHelper::DOCUMENT_TITLE, organization["alternateName"]
        assert_equal PublicPost.email, organization["email"]
        assert_equal "PO Box 11", organization.dig("address", "streetAddress")
        assert_equal PublicPost::MEETING_NAME, organization.dig("location", "name")
        assert_equal "7227 Sandy Hill Ln", organization.dig("location", "address", "streetAddress")
        assert_equal PublicPost::PARENT_NAME, organization.dig("parentOrganization", "name")
        assert_equal [ PublicPost::FACEBOOK_URL ], organization["sameAs"]
        refute_phone(organization)
        assert_not_includes response.body, "event_withheld"

        get event_path(upcoming.fetch("id")), headers: { "Turbo-Frame" => "event-details" }
        assert_response :success
        assert_not_includes response.body, "application/ld+json"

        get event_path(no_address.fetch("id"))
        assert_response :success
        plain = json_ld_blocks.find { |data| data["@type"] == "Event" }
        assert_equal "Gathering without a street address", plain["name"]
        refute plain.key?("location")
        refute_phone(plain)

        get event_path(all_day.fetch("id"))
        assert_response :success
        day = json_ld_blocks.find { |data| data["@type"] == "Event" }
        assert_equal "2026-12-01T00:00:00-06:00", day["startDate"]
        assert_equal "Example location — not a real event", day.dig("location", "name")
        refute day["location"].key?("address")
        refute day.key?("description")
        assert_not_includes day.to_json, GUESTS_LINE

        get event_path(past.fetch("id"))
        assert_response :success
        assert_select "h1", past.fetch("title")
        assert json_ld_blocks.any? { |data| data["@type"] == "Event" && data["startDate"] == "2026-10-03T18:00:00-05:00" }

        get event_path(cancelled.fetch("id"))
        assert_response :success
        assert_includes response.body, "This event has been cancelled."
        assert_nil json_ld_blocks.find { |data| data["@type"] == "Event" }
        assert json_ld_blocks.any? { |data| data["@type"] == "Organization" }

        get event_path(funeral.fetch("id"))
        assert_response :not_found
        assert_not_includes response.body, "Honor funeral"
        assert_not_includes response.body, "application/ld+json"

        get event_path(titled_funeral.fetch("id"))
        assert_response :not_found
        assert_not_includes response.body, "Military funeral honors"
        assert_not_includes response.body, "application/ld+json"

        get events_path
        assert_response :success
        assert_includes response.body, "Upcoming public gathering"
        assert_includes response.body, "Cancelled public gathering"
        assert_not_includes response.body, "Honor funeral"
        assert_not_includes response.body, "Military funeral honors"

        get root_path
        assert_response :success
        website = json_ld_blocks.find { |data| data["@type"] == "WebSite" }
        assert_equal "WebSite", website["@type"]
        assert_equal({ "@id" => ORGANIZATION_ID }, website["publisher"])
        refute_phone(website)
        refute_phone(json_ld_blocks.find { |data| data["@type"] == "Organization" })

        Rails.configuration.x.public_site_edition = "v2"
        get event_path(upcoming.fetch("id"))
        assert_response :success
        assert_select "#company"
        v2_event = json_ld_blocks.find { |data| data["@type"] == "Event" }
        assert_equal "Synthetic event for contract testing.", v2_event["description"]
        assert_not_includes v2_event.to_json, GUESTS_LINE
        assert_includes response.body, GUESTS_LINE
      end
    end
  end

  test "llms.txt repeats the visit and contact facts and omits a blank email" do
    get "/visit"
    assert_response :success
    assert_includes response.body, "Manitowoc Rifle"
    assert_includes response.body, PublicPost::MEETING_STREET
    assert_includes response.body, "6:30 p.m."

    get "/contact"
    assert_response :success
    assert_includes response.body, "PO Box 11"
    assert_includes response.body, "Two Rivers, WI 54241"
    assert_includes response.body, PublicPost.email

    Rails.configuration.x.public_contact_email = ""
    get "/llms.txt"
    assert_response :success
    assert_not_includes response.body, "Email:"
    assert_not_includes response.body, "wipost165@gmail.com"
    assert_includes response.body, PublicPost.mailing_summary

    get "/contact"
    organization = json_ld_blocks.find { |data| data["@type"] == "Organization" }
    refute organization.key?("email")
    refute_phone(organization)
  end

  test "sitemap main pages have recorded content dates" do
    %w[v1 v2].each do |edition|
      Rails.configuration.x.public_site_edition = edition
      get "/sitemap.xml"
      assert_response :success
      PublicSiteHelper::SITEMAP_PATHS.each do |path|
        lastmod = sitemap_lastmod(path)
        assert lastmod, "#{edition} #{path} is missing lastmod"
        assert_valid_content_date(lastmod)
      end
    end
  end

  test "coming soon sitemap and llms.txt stay on the holding page" do
    Rails.configuration.x.public_site_coming_soon = true
    Publishing::Client.stub(:new, -> { raise "Publisher must not be contacted" }) do
      get "/sitemap.xml"
      assert_response :success
      assert_includes response.body, "<loc>#{ORIGIN}/</loc>"
      assert_includes response.body, "<lastmod>#{PublicPageRevisions.at("coming_soon").iso8601}</lastmod>"
      assert_valid_content_date(sitemap_lastmod("/"))
      assert_not_includes response.body, "<loc>#{ORIGIN}/events</loc>"
      assert_not_includes response.body, "/events/"

      get "/llms.txt"
      assert_response :success
      assert_includes response.body, PublicPost::NAME
      assert_not_includes response.body, "Honor funeral"
    end
  end
end
