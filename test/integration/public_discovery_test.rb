require "test_helper"
require "minitest/mock"
require_relative "../support/publishing_helpers"

class PublicDiscoveryTest < ActionDispatch::IntegrationTest
  include PublishingHelpers

  MEASUREMENT_ID = "G-TESTMEASURE1"

  setup do
    build_client
    @settings = %i[
      ga4_measurement_id
      public_site_edition public_site_coming_soon public_site_preview public_site_launch_ready
    ].to_h { |key| [ key, Rails.configuration.x.public_send(key) ] }
    Rails.configuration.x.public_site_preview = false
    Rails.configuration.x.public_site_launch_ready = true
    Rails.configuration.x.public_site_coming_soon = false
    Rails.configuration.x.ga4_measurement_id = nil
  end

  teardown do
    @settings.each { |key, value| Rails.configuration.x.public_send("#{key}=", value) }
  end

  def using_feed(&block)
    constructor = Publishing::Client.method(:new)
    factory = -> { constructor.call(token: "website-test-token", cache: @cache, transport: @transport, clock: -> { @now }) }
    Publishing::Client.stub(:new, factory, &block)
  end

  def configure_tag
    Rails.configuration.x.ga4_measurement_id = MEASUREMENT_ID
  end

  def assert_tags_present
    src = "https://www.googletagmanager.com/gtag/js?id=#{MEASUREMENT_ID}"
    assert_select "script[src=?][async][fetchpriority=low]", src
    assert_match(/gtag\('config', #{Regexp.escape(MEASUREMENT_ID.to_json)}\)/, response.body)
    assert_match(/turbo:load/, response.body)
    assert_select 'meta[name="google-site-verification"], meta[name="msvalidate.01"]', count: 0
    assert_select "script[nonce]", count: 0
  end

  def assert_tags_absent
    assert_select 'script[src*="googletagmanager"], script[src*="google-analytics"]', count: 0
    assert_no_match(/gtag\(/, response.body)
    assert_select 'meta[name="google-site-verification"], meta[name="msvalidate.01"]', count: 0
  end

  test "blank analytics env values are accepted and malformed tokens are rejected" do
    assert_nil PublicSiteEnv.measurement_id("  ")
    assert_equal MEASUREMENT_ID, PublicSiteEnv.measurement_id(" #{MEASUREMENT_ID} ")
    assert_raises(ArgumentError) { PublicSiteEnv.measurement_id("UA-1234-1") }
    assert_equal "G-KVBQMTBJYB", PublicSiteEnv.measurement_id("G-KVBQMTBJYB")
  end

  test "the google tag is omitted when unset for both editions and coming soon" do
    %w[v1 v2].each do |edition|
      Rails.configuration.x.public_site_edition = edition
      @replies << Publishing::Unavailable.new("offline")
      using_feed { get root_path }
      assert_response :success
      assert_select edition == "v1" ? "#launch" : "#company"
      assert_tags_absent
    end

    Rails.configuration.x.public_site_coming_soon = true
    get root_path
    assert_response :success
    assert_select "h1", "Website coming soon."
    assert_tags_absent
  end

  test "the google tag renders for both editions and coming soon" do
    configure_tag
    %w[v1 v2].each do |edition|
      Rails.configuration.x.public_site_edition = edition
      @replies << Publishing::Unavailable.new("offline")
      using_feed { get root_path, params: { ga: "G-FROMQUERY" } }
      assert_response :success
      assert_select edition == "v1" ? "#launch" : "#company"
      assert_tags_present
      assert_not_includes response.body, "G-FROMQUERY"
    end

    Rails.configuration.x.public_site_coming_soon = true
    get root_path
    assert_response :success
    assert_select "h1", "Website coming soon."
    assert_tags_present
  end

  test "blank or malformed analytics values render nothing" do
    Rails.configuration.x.public_site_coming_soon = true
    Rails.configuration.x.ga4_measurement_id = "  "
    get root_path
    assert_tags_absent

    Rails.configuration.x.ga4_measurement_id = "G-TEST');alert(1);//"
    get root_path
    assert_tags_absent
    assert_no_match(/alert\(1\)/, response.body)
  end

  test "health check and event dialog do not load the google tag" do
    configure_tag
    get "/up"
    assert_response :success
    assert_not_includes response.body, "googletagmanager"
    assert_not_includes response.body, "gtag"

    Rails.configuration.x.public_site_edition = "v1"
    event = fixture("events").fetch("events").first
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => event })
    using_feed { get event_path(event.fetch("id")), headers: { "Turbo-Frame" => "event-details" } }
    assert_response :success
    assert_not_includes response.body, "googletagmanager"
    assert_not_includes response.body, "<html"
  end

  test "robots allows crawling and points at the apex sitemap" do
    [ "wipost165.org", "www.wipost165.org" ].each do |host|
      host! host
      get "/robots.txt"
      assert_response :success
      assert_equal "text/plain", response.media_type
      assert_match(/^User-agent: \*$/, response.body)
      assert_match(/^Disallow:\s*$/, response.body)
      assert_no_match(/^Disallow: \//, response.body)
      assert_includes response.body, "Sitemap: https://wipost165.org/sitemap.xml"
      assert_not_includes response.body, host == "www.wipost165.org" ? "Sitemap: https://www.wipost165.org" : "example.com"
      assert_match(/max-age=3600/, response.headers["Cache-Control"])
      assert_match(/public/, response.headers["Cache-Control"])
    end
  end

  test "sitemap lists static public pages and only the homepage while coming soon" do
    %w[v1 v2].each do |edition|
      Rails.configuration.x.public_site_edition = edition
      Rails.configuration.x.public_site_coming_soon = false
      get "/sitemap.xml"
      assert_response :success
      assert_equal "application/xml", response.media_type
      PublicSiteHelper::SITEMAP_PATHS.each do |path|
        assert_includes response.body, "<loc>https://wipost165.org#{path}</loc>"
      end
      assert_not_includes response.body, "/people"
      assert_not_includes response.body, "/events/"
      assert_not_includes response.body, "<html"
    end

    Rails.configuration.x.public_site_coming_soon = true
    get "/sitemap.xml"
    assert_response :success
    assert_includes response.body, "<loc>https://wipost165.org/</loc>"
    assert_not_includes response.body, "<loc>https://wipost165.org/events</loc>"
    assert_not_includes response.body, "<loc>https://wipost165.org/visit</loc>"

    get "/robots.txt"
    assert_includes response.body, "Sitemap: https://wipost165.org/sitemap.xml"
    assert_match(/^Disallow:\s*$/, response.body)
  end
end
