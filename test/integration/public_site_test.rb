require "test_helper"
require "minitest/mock"
require_relative "../support/publishing_helpers"

class PublicSiteTest < ActionDispatch::IntegrationTest
  include PublishingHelpers

  setup do
    build_client
    @preview = Rails.configuration.x.public_site_preview
    Rails.configuration.x.public_site_preview = false
  end

  teardown { Rails.configuration.x.public_site_preview = @preview }

  def using_feed(&block)
    constructor = Publishing::Client.method(:new)
    factory = -> { constructor.call(cache: @cache, transport: @transport, clock: -> { @now }) }
    Publishing::Client.stub(:new, factory, &block)
  end

  test "home serves the selected published people and no-store HTML" do
    @replies << publisher_response(fixture("featured"))
    using_feed { get root_path }
    assert_response :success
    assert_select "h1", text: /In goodcompany/
    assert_select 'a[href="/people/story_example_avery"]', minimum: 1
    assert_select ".sample-tag", count: 0
    assert_equal "no-store", response.headers["Cache-Control"]
    assert_select 'meta[name="turbo-cache-control"][content="no-cache"]'
  end

  test "all static routes remain usable during publisher failure" do
    @replies << Publishing::Unavailable.new("offline")
    using_feed do
      %w[/ /visit /about /contact /membership /veteran-help].each do |path|
        get path
        assert_response :success
        assert_select "h1", count: 1
        assert_select ".person", count: 0
      end
    end
  end

  test "profile is independent of featured placement and copy is escaped" do
    @replies << publisher_response(fixture("featured").merge("members" => []))
    member = fixture("featured")["members"].first.merge("story" => '<script>alert("x")</script>Real text')
    @replies << publisher_response({ "schema_version" => 1, "member" => member })
    using_feed { get person_path(member["id"]) }
    assert_response :success
    assert_select "h1", text: "Meet Avery."
    assert_select ".member-story script", count: 0
    assert_includes response.body, "&lt;script&gt;"
  end

  test "withdrawn detail disappears including its already loaded homepage portrait" do
    @replies << publisher_response(fixture("featured"))
    @replies << publisher_response(nil, status: 404)
    using_feed { get person_path("story_example_avery") }
    assert_response :not_found
    assert_select ".person", count: 0
  end

  test "detail outage is 503 and not a false 404" do
    @replies << publisher_response(fixture("featured").merge("members" => []))
    @replies << Publishing::Unavailable.new("offline")
    using_feed { get person_path("story_example_avery") }
    assert_response :service_unavailable
    assert_equal "10", response.headers["Retry-After"]
  end

  test "empty and unavailable calendars have different explanations" do
    travel_to Time.utc(2026, 10, 1, 12) do
      @replies << publisher_response(fixture("featured").merge("members" => []))
      data = fixture("events").merge("from" => "2026-10-01", "to" => "2026-12-30", "events" => [])
      @replies << publisher_response(data)
      using_feed { get events_path }
      assert_response :success
      assert_includes response.body, "There aren’t any upcoming public dates"
      @now += 301
      @replies << Publishing::Unavailable.new("offline")
      @replies << Publishing::Unavailable.new("offline")
      using_feed { get events_path }
      assert_includes response.body, "calendar is temporarily unavailable"
      assert_not_includes response.body, "There aren’t any upcoming public dates"
    end
  end

  test "cancelled all-day event shows exclusive end as last actual day" do
    @replies << publisher_response(fixture("featured").merge("members" => []))
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => fixture("events")["events"].last })
    using_feed { get event_path("event_example_2") }
    assert_response :success
    assert_includes response.body, "October 11, 2026"
    assert_includes response.body, "All day"
    assert_includes response.body, "has been cancelled"
    assert_select "a", text: "Thinking of coming? →", count: 0
  end

  test "preview content cannot be requested by query string or accidentally substituted" do
    @replies << publisher_response(fixture("featured").merge("members" => []))
    using_feed { get root_path, params: { preview: "1" } }
    assert_not_includes response.body, "DESIGN PREVIEW"
    assert_not_includes response.body, "sample-frank"
  end

  test "explicit development preview keeps three placeholders with no feed requests" do
    Rails.configuration.x.public_site_preview = true
    using_feed { get root_path }
    assert_response :success
    assert_select ".person", count: 3
    assert_equal "noindex, nofollow", response.headers["X-Robots-Tag"]
    assert_empty @requests
  end

  test "old editor routes no longer exist" do
    using_feed do
      get "/manage"
      assert_response :not_found
      patch "/manage/people/rotation", params: { person_ids: [ 1, 2, 3 ] }
      assert_response :not_found
    end
  end
  test "zero through three featured members render without invented replacements" do
    (0..3).each do |count|
      @cache.clear
      data = fixture("featured")
      template = data["members"].first
      data["members"] = count.times.map do |index|
        record = Marshal.load(Marshal.dump(template))
        record["id"] = "story_#{index}"
        record["portrait"]["variants"].each { |variant| variant["url"].sub!(template["id"], record["id"]) }
        record
      end
      @replies << publisher_response(data)
      using_feed { get root_path }
      assert_response :success
      assert_select ".person", count: count
    end
  end

  test "content expiring while another section loads is not sent as fresh HTML" do
    constructor = Publishing::Client.method(:new)
    calls = 0
    transport = lambda do |_uri, _headers|
      calls += 1
      if calls == 1
        publisher_response(fixture("featured"), headers: { "age" => "299" })
      else
        @now += 2
        publisher_response({ "schema_version" => 1, "member" => fixture("featured")["members"].first })
      end
    end
    factory = -> { constructor.call(cache: @cache, transport: transport, clock: -> { @now }) }
    Publishing::Client.stub(:new, factory) { get person_path("story_example_avery") }
    assert_response :service_unavailable
    assert_select ".person", count: 0
    assert_select "#person-title", count: 0
    assert_equal "no-store", response.headers["Cache-Control"]
  end
  test "returning visitors can render with a real CSRF session cookie" do
    old_protection = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    Rails.configuration.x.public_site_preview = true
    using_feed do
      get root_path
      assert_response :success
      assert_select 'meta[name="csrf-token"]'
      assert response.headers["Set-Cookie"].present?
      get visit_path(person: "frank")
      assert_response :success
      assert_select "h1", text: "Start with hello."
    end
  ensure
    ActionController::Base.allow_forgery_protection = old_protection
  end
end
