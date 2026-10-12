require "test_helper"
require "minitest/mock"
require_relative "../support/publishing_helpers"

class PublicPageMetadataTest < ActionDispatch::IntegrationTest
  include PublishingHelpers

  SITE = PublicSiteHelper::DOCUMENT_TITLE
  PAGES = {
    "v1" => {
      "/" => [ SITE, PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "home"), "Military service is our common bond." ],
      "/events" => [ "Come on by – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "events"), "Find a date and make a plan." ],
      "/visit" => [ "Start with hello – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "visit"), "We meet the first Tuesday of each month at 6:30 p.m." ],
      "/about" => [ "Still serving together – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "about"), "Military service is our common bond." ],
      "/contact" => [ "Say hello – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "contact"), "Questions about a first visit, membership, or getting involved?" ],
      "/membership" => [ "Let’s talk – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "membership"), "National’s membership questions explain eligibility and how membership works." ],
      "/veteran-help" => [ "A place to ask – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "help"), "For questions about veterans benefits, start with the Manitowoc County Veteran Services Office." ]
    },
    "v2" => {
      "/" => [ SITE, PublicSiteHelper::V2_HOME_WITHOUT_PEOPLE, "Get to know your local American Legion Post." ],
      "/events" => [ "Come on by – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v2", "events"), "Public occasions over the next three months." ],
      "/visit" => [ "Start with hello – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v2", "visit"), "Regular Post meetings are on the first Tuesday of each month at 6:30 p.m." ],
      "/about" => [ "Still serving together – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "about"), "Military service is our common bond." ],
      "/contact" => [ "Say hello – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v2", "contact"), "Questions about coming along, membership, or the Post?" ],
      "/membership" => [ "Let’s talk – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "membership"), "National’s membership questions explain eligibility and how membership works." ],
      "/veteran-help" => [ "A place to ask – #{SITE}", PublicSiteHelper::PAGE_DESCRIPTIONS.dig("v1", "help"), "For questions about veterans benefits, start with the Manitowoc County Veteran Services Office." ]
    }
  }.freeze

  setup do
    build_client
    @settings = %i[public_site_edition public_site_coming_soon public_site_preview public_site_launch_ready].to_h do |key|
      [ key, Rails.configuration.x.public_send(key) ]
    end
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

  test "each launched page has its own title, description, and apex canonical" do
    PAGES.each do |edition, pages|
      Rails.configuration.x.public_site_edition = edition
      using_feed do
        pages.each do |path, (title, description, phrase)|
          @replies << Publishing::Unavailable.new("offline") if edition == "v2" || %w[/ /events].include?(path)
          host! "www.wipost165.org"
          get path, params: { utm_source: "newsletter", person: "frank" }
          assert_response :success, "#{edition} #{path}"
          assert_equal title, css_select("title").first.text
          assert_select 'meta[name="description"][content=?]', description
          assert_includes description, phrase
          assert_includes response.body, phrase
          assert_operator description.length, :>=, 70
          assert_operator description.length, :<=, 160
          assert_select 'link[rel="canonical"][href=?]', "https://wipost165.org#{path}"
          assert_select 'link[rel="canonical"]', count: 1
          assert_no_match(/[?&]utm_source|[?&]person=/, css_select('link[rel="canonical"]').first["href"])
          assert_select 'meta[property^="og:"], meta[name^="twitter:"], meta[property="og:image"]', count: 0
        end
      end
    end
  end

  test "a v2 home with published people describes the people on that page" do
    Rails.configuration.x.public_site_edition = "v2"
    @replies << publisher_response(fixture("featured"))
    using_feed { get root_path }
    assert_response :success
    assert_equal SITE, css_select("title").first.text
    assert_select 'meta[name="description"][content=?]', PublicSiteHelper::V2_HOME_WITH_PEOPLE
    assert_includes response.body, "A few faces to know before you walk in."
    assert_select 'link[rel="canonical"][href="https://wipost165.org/"]'
  end

  test "coming soon keeps one title and description and a query-free canonical" do
    Rails.configuration.x.public_site_coming_soon = true
    %w[v1 v2].each do |edition|
      Rails.configuration.x.public_site_edition = edition
      get "/visit", params: { utm_source: "newsletter" }
      assert_response :success
      assert_equal "Website coming soon – #{SITE}", css_select("title").first.text
      assert_select 'meta[name="description"][content=?]', PublicSiteHelper::COMING_SOON_DESCRIPTION
      assert_operator PublicSiteHelper::COMING_SOON_DESCRIPTION.length, :<=, 160
      assert_includes response.body, "We’re preparing our new website."
      assert_select 'link[rel="canonical"][href="https://wipost165.org/visit"]'
      assert_select 'meta[property^="og:"], meta[name^="twitter:"]', count: 0
    end
  end

  test "sitemap lists every launched page and only the homepage while coming soon" do
    %w[v1 v2].each do |edition|
      Rails.configuration.x.public_site_edition = edition
      Rails.configuration.x.public_site_coming_soon = false
      get "/sitemap.xml"
      assert_response :success
      PAGES.fetch(edition).each_key do |path|
        assert_includes response.body, "<loc>https://wipost165.org#{path}</loc>"
      end
      assert_not_includes response.body, "/people"
    end

    Rails.configuration.x.public_site_coming_soon = true
    get "/sitemap.xml"
    assert_includes response.body, "<loc>https://wipost165.org/</loc>"
    assert_not_includes response.body, "<loc>https://wipost165.org/visit</loc>"

    get "/robots.txt"
    assert_includes response.body, "Sitemap: https://wipost165.org/sitemap.xml"
  end
end
