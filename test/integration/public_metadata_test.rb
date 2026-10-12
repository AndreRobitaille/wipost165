require "test_helper"
require "minitest/mock"
require_relative "../support/publishing_helpers"

class PublicMetadataTest < ActionDispatch::IntegrationTest
  include PublishingHelpers

  setup do
    build_client
    @settings = %i[public_site_preview public_site_coming_soon public_site_launch_ready public_site_edition].to_h do |key|
      [ key, Rails.configuration.x.public_send(key) ]
    end
    Rails.configuration.x.public_site_preview = false
    Rails.configuration.x.public_site_coming_soon = false
    Rails.configuration.x.public_site_launch_ready = true
    Rails.configuration.x.public_site_edition = "v2"
  end

  teardown do
    @settings.each { |key, value| Rails.configuration.x.public_send("#{key}=", value) }
  end

  def using_feed(&block)
    constructor = Publishing::Client.method(:new)
    factory = -> { constructor.call(token: "website-test-token", cache: @cache, transport: @transport, clock: -> { @now }) }
    Publishing::Client.stub(:new, factory, &block)
  end

  def assert_not_indexable
    assert_includes response.headers["X-Robots-Tag"], "noindex"
    assert_select 'meta[name="robots"][content*="noindex"]'
    assert_select 'meta[property^="og:"], meta[name^="twitter:"]', count: 0
  end

  def assert_apex_canonical(path)
    assert_select 'link[rel="canonical"][href=?]', "https://wipost165.org#{path}", count: 1
  end

  test "live-feed development has neutral metadata without fictional details" do
    Rails.configuration.x.public_site_launch_ready = false
    member = fixture("featured")["members"].first
    @replies << publisher_response(fixture("featured"))
    @replies << publisher_response({ "schema_version" => 1, "member" => member })
    using_feed { get person_path(member["id"]) }
    assert_response :success
    assert_select "h1", text: "Meet Avery."
    assert_not_indexable
    assert_select "title", text: "Meet Avery – #{PublicSiteHelper::DOCUMENT_TITLE}"
    assert_apex_canonical(person_path(member["id"]))
    assert_select "head" do |head|
      assert_not_includes head.to_s, "/portrait/"
    end
    assert_equal "no-store", response.headers["Cache-Control"]
  end

  test "preview and coming soon override launch readiness without contacting the publisher" do
    Publishing::Client.stub(:new, -> { raise "Publisher must not be contacted" }) do
      Rails.configuration.x.public_site_coming_soon = true
      get "/people/example"
      assert_response :success
      assert_not_indexable
      assert_select "title", text: "Website coming soon – #{PublicSiteHelper::DOCUMENT_TITLE}"
      assert_select 'meta[name="description"][content=?]', PublicSiteHelper::COMING_SOON_DESCRIPTION
      assert_apex_canonical("/people/example")
    end
    Rails.configuration.x.public_site_coming_soon = false
    Rails.configuration.x.public_site_preview = true
    using_feed { get person_path("frank") }
    assert_response :success
    assert_not_indexable
    assert_select "title", text: "Meet Frank – #{PublicSiteHelper::DOCUMENT_TITLE}"
    assert_apex_canonical("/people/frank")
    assert_empty @requests
  end

  test "launched static pages have distinct descriptions and fixed apex canonical URLs" do
    @replies << publisher_response(fixture("featured").merge("members" => []))
    descriptions = []
    using_feed do
      [ "wipost165.org", "www.wipost165.org" ].each do |host|
        host! host
        %w[/ /why-the-legion /visit /about /contact /membership /veteran-help].each do |path|
          get path, params: { utm_source: "test", preview: "1" }
          assert_response :success
          assert_nil response.headers["X-Robots-Tag"]
          assert_select 'meta[name="robots"]', count: 0
          assert_apex_canonical(path)
          assert_select 'meta[property^="og:"], meta[name^="twitter:"]', count: 0
          assert_select 'meta[name="description"]' do |tags|
            descriptions << tags.first["content"] if host == "wipost165.org"
          end
        end
      end
    end
    assert_equal 7, descriptions.uniq.size
    assert_equal 1, @requests.size
  end

  test "canonical and sharing metadata exclude recognition context and request host" do
    member = fixture("featured")["members"].first
    @replies << publisher_response(fixture("featured"))
    @replies << publisher_response({ "schema_version" => 1, "member" => member })
    host! "unexpected.example"
    using_feed { get visit_path, params: { person: member["id"], utm_source: "friend" } }
    assert_response :success
    assert_apex_canonical("/visit")
    assert_select 'meta[property^="og:"], meta[name^="twitter:"]', count: 0
    assert_select "head" do |head|
      assert_not_includes head.to_s, "unexpected.example"
      assert_not_includes head.to_s, member["id"]
      assert_not_includes head.to_s, "website-test-token"
    end
  end

  test "published introduction metadata is bounded and escapes authored text" do
    member = fixture("featured")["members"].first
    member["display_name"] = 'Avery "Example" <script>alert(1)</script>'
    member["introduction"] = 'A "quote" <img src=x onerror=alert(1)> ' + "Long introduction. " * 30
    @replies << publisher_response(fixture("featured").merge("members" => []))
    @replies << publisher_response({ "schema_version" => 1, "member" => member })
    using_feed { get person_path(member["id"]) }
    assert_response :success
    assert_select "title", text: "Meet #{member['display_name']} – #{PublicSiteHelper::DOCUMENT_TITLE}"
    assert_select 'meta[name="description"]' do |tags|
      assert_equal member["introduction"].squish.truncate(150), tags.first["content"]
      assert_operator tags.first["content"].length, :<=, 150
    end
    assert_apex_canonical("/people/#{member['id']}")
    assert_select "head img, head script:not([type='importmap']):not([type='module'])", count: 0
    assert_select 'meta[property^="og:"], meta[name^="twitter:"]', count: 0
  end

  test "cancelled event metadata leads with its status and includes the public date" do
    @replies << publisher_response(fixture("featured").merge("members" => []))
    event = fixture("events")["events"].last
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => event })
    using_feed { get event_path(event["id"]) }
    assert_response :success
    assert_select "title", text: "#{event['title']} – #{PublicSiteHelper::DOCUMENT_TITLE}"
    assert_select 'meta[name="description"]' do |tags|
      assert_match(/\AThis event has been cancelled\./, tags.first["content"])
      assert_includes tags.first["content"], "October 11, 2026"
      assert_operator tags.first["content"].length, :<=, 150
    end
    assert_apex_canonical("/events/#{event['id']}")
  end

  test "withdrawn and unavailable details have error metadata and a self canonical" do
    @replies << publisher_response(fixture("featured").merge("members" => []))
    @replies << publisher_response(nil, status: 404)
    using_feed { get person_path("missing"), params: { utm_source: "test" } }
    assert_response :not_found
    assert_not_indexable
    assert_select "title", text: "That page isn’t here – #{PublicSiteHelper::DOCUMENT_TITLE}"
    assert_apex_canonical("/people/missing")

    @replies << Publishing::Unavailable.new("offline")
    @replies << Publishing::Unavailable.new("offline")
    using_feed { get event_path("unavailable") }
    assert_response :service_unavailable
    assert_not_indexable
    assert_select "title", text: "Please check back shortly – #{PublicSiteHelper::DOCUMENT_TITLE}"
    assert_apex_canonical("/events/unavailable")
  end

  test "a valid empty calendar is indexable while an outage is not" do
    travel_to Time.utc(2026, 10, 1, 12) do
      @replies << publisher_response(fixture("featured").merge("members" => []))
      @replies << publisher_response(fixture("events").merge("to" => "2026-12-30", "events" => []))
      using_feed { get events_path }
      assert_response :success
      assert_nil response.headers["X-Robots-Tag"]
      assert_apex_canonical("/events")
      assert_select "title", text: "Events – #{PublicSiteHelper::DOCUMENT_TITLE}"

      @now += 301
      @replies << Publishing::Unavailable.new("offline")
      @replies << Publishing::Unavailable.new("offline")
      using_feed { get events_path }
      assert_response :success
      assert_not_indexable
      assert_select "title", text: "Events – #{PublicSiteHelper::DOCUMENT_TITLE}"
    end
  end

  test "expiry during page assembly discards previously prepared detail metadata" do
    member = fixture("featured")["members"].first
    calls = 0
    transport = lambda do |_uri, _headers|
      calls += 1
      if calls == 1
        publisher_response(fixture("featured"), headers: { "age" => "299" })
      else
        @now += 2
        publisher_response({ "schema_version" => 1, "member" => member })
      end
    end
    client = Publishing::Client.new(token: "website-test-token", cache: @cache, transport: transport, clock: -> { @now })
    Publishing::Client.stub(:new, client) { get person_path(member["id"]) }
    assert_response :service_unavailable
    assert_not_indexable
    assert_select "title", text: "Please check back shortly – #{PublicSiteHelper::DOCUMENT_TITLE}"
    assert_select "title", text: /Avery/, count: 0
    assert_select 'meta[name="description"]' do |tags|
      assert_not_includes tags.first["content"], "Avery"
    end
  end

  test "portrait indexing is disabled before release and on all errors" do
    path = published_portrait_path(id: "story_example_avery", revision: "portrait_example_2", size: "small")
    using_feed do
      Rails.configuration.x.public_site_launch_ready = false
      @replies << portrait_response
      get path
      assert_response :success
      assert_includes response.headers["X-Robots-Tag"], "noindex"
      Rails.configuration.x.public_site_launch_ready = true
      head path
      assert_response :success
      assert_nil response.headers["X-Robots-Tag"]
      @now += 301
      @replies << publisher_response(nil, status: 404)
      get path
      assert_response :not_found
      assert_includes response.headers["X-Robots-Tag"], "noindex"
    end
  end
end
