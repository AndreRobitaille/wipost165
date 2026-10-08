require "test_helper"
require "minitest/mock"
require_relative "../support/publishing_helpers"

class LaunchSiteTest < ActionDispatch::IntegrationTest
  include PublishingHelpers

  setup do
    build_client
    @settings = %i[public_site_edition public_site_preview public_site_coming_soon public_site_launch_ready].to_h do |key|
      [ key, Rails.configuration.x.public_send(key) ]
    end
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

  def event_collection(events = fixture("events").fetch("events"))
    fixture("events").merge("from" => Date.current.iso8601, "to" => (Date.current + 90).iso8601, "events" => events)
  end

  test "launch home selects the earliest active occasion and only reads events" do
    travel_to Time.utc(2026, 10, 1, 12) do
      events = fixture("events").fetch("events")
      early_cancelled = events.first.merge("id" => "cancelled", "cancelled" => true, "starts_at" => "2026-10-02T18:00:00-05:00", "ends_at" => nil)
      @replies << publisher_response(event_collection([ early_cancelled, events.first, events.last ]))
      using_feed { get root_path, params: { person: "story_example_avery", edition: "v2", preview: "1" } }
      assert_response :success
      assert_select "#launch", count: 1
      assert_select "#invitation-title", text: events.first.fetch("title")
      assert_select 'a[href^="/people"]', count: 0
      assert_select ".launch-harbor img[alt*='Illustration of Two Rivers']", count: 1
      assert_select 'img[src*="portrait"], img[src*="people"]', count: 0
      assert_select '.launch-harbor a[href="https://creativecommons.org/licenses/by-sa/4.0/"]'
      assert_not_includes response.body, "?person="
      assert_equal 1, @requests.size
      assert_equal "/public/v1/events", @requests.first.first.path
      assert_nil response.headers["X-Robots-Tag"]
      assert_select 'link[rel="canonical"][href="https://wipost165.org/"]'
    end
  end

  test "the next invitation skips timed occasions that already started today" do
    travel_to Time.utc(2026, 10, 3, 23, 30) do
      started = fixture("events").fetch("events").first
      upcoming = started.merge("id" => "next", "title" => "Next example occasion", "starts_at" => "2026-10-04T18:00:00-05:00")
      @replies << publisher_response(event_collection([ started, upcoming ]))
      using_feed { get root_path }
      assert_response :success
      assert_select "#invitation-title", text: upcoming.fetch("title")
      assert_select "a[href=?]", event_path(started.fetch("id")), count: 0
    end
  end

  test "direct stories and both portrait sizes are unavailable without contacting the publisher" do
    Publishing::Client.stub(:new, -> { raise "V1 people routes must not contact the publisher" }) do
      get person_path("story_example_avery"), params: { edition: "v2" }
      assert_response :not_found
      assert_select 'meta[name="robots"][content*="noindex"]'
      assert_select 'link[rel="canonical"]', count: 0
      %w[small large].each do |size|
        path = published_portrait_path(id: "story_example_avery", revision: "portrait_example_2", size: size)
        get path
        assert_response :not_found
        assert_empty response.body
        assert_equal "no-store", response.headers["Cache-Control"]
        head path
        assert_response :not_found
      end
    end
  end

  test "practical pages ignore person context and make no publisher requests" do
    using_feed do
      %w[/why-the-legion /visit /about /contact /membership /veteran-help].each do |path|
        get path, params: { person: "story_example_avery" }
        assert_response :success
        assert_select "h1", count: 1
        assert_select 'a[href^="/people"]', count: 0
        assert_select ".recognition", count: 0
        assert_not_includes response.body, "?person="
        assert_equal "no-store", response.headers["Cache-Control"]
        if path == why_legion_path
          assert_select ".launch-nav a[aria-current=page][href=?]", why_legion_path, count: 1
          assert_select ".why-next a[href=?]", events_path
          assert_select ".why-next a[href=?]", visit_path
          assert_select ".why-next a[href=?]", membership_path
        end
      end
    end
    assert_empty @requests
  end

  test "empty and unavailable home invitations stay distinct and preserve practical guidance" do
    @replies << publisher_response(event_collection([]))
    using_feed { get root_path }
    assert_response :success
    assert_includes response.body, "No upcoming public occasions are listed"
    assert_nil response.headers["X-Robots-Tag"]

    @now += 301
    @replies << Publishing::Unavailable.new("offline")
    using_feed { get root_path }
    assert_response :success
    assert_includes response.body, "calendar is temporarily unavailable"
    assert_not_includes response.body, "No upcoming public occasions are listed"
    assert_includes response.body, "Regular Post meetings"
    assert_includes response.headers["X-Robots-Tag"], "noindex"
  end

  test "cancelled occasions remain visible on the calendar but are not promoted as the next occasion" do
    travel_to Time.utc(2026, 10, 1, 12) do
      cancelled = fixture("events").fetch("events").last
      @replies << publisher_response(event_collection([ cancelled ]))
      using_feed do
        get root_path
        assert_select ".launch-date", count: 0
        assert_select "a[href=?]", event_path(cancelled.fetch("id")), count: 0
        get events_path
        assert_select ".cancelled-tag", text: "CANCELLED"
        assert_select "a[href=?]", event_path(cancelled.fetch("id"))
      end
      assert_equal 1, @requests.size
    end
  end

  test "event details work without fetching or remembering profiles" do
    event = fixture("events").fetch("events").first
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => event })
    using_feed { get event_path(event.fetch("id")), params: { person: "story_example_avery" } }
    assert_response :success
    assert_select "h1", text: event.fetch("title")
    assert_select ".recognition", count: 0
    assert_select 'a[href^="/people"]', count: 0
    assert_equal [ "/public/v1/events/#{event.fetch('id')}" ], @requests.map { |uri, _headers| uri.path }
  end

  test "the calendar offers modal details without eagerly fetching individual events" do
    travel_to Time.utc(2026, 10, 1, 12) do
      @replies << publisher_response(event_collection)
      using_feed { get events_path }
    end
    assert_response :success
    assert_select ".launch-nav a:first-child[href=?]", root_path, text: "Home"
    assert_select ".launch-nav a[aria-current=page][href=?]", events_path
    assert_select ".launch-event-card[aria-haspopup=dialog][data-action='click->event-dialog#open'][data-turbo-prefetch=false]", count: 2
    assert_select "dialog turbo-frame#event-details", count: 1
    assert_select "dialog turbo-frame[src]", count: 0
    assert_equal [ "/public/v1/events" ], @requests.map { |uri, _headers| uri.path }
  end

  test "modal responses contain escaped event details without a page layout or profiles" do
    event = fixture("events").fetch("events").first.merge("description" => "An example <script>alert('test')</script> invitation.")
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => event })
    using_feed { get event_path(event.fetch("id")), headers: { "Turbo-Frame" => "event-details" } }
    assert_response :success
    assert_select "turbo-frame#event-details", count: 1
    assert_select "h2#event-title[tabindex='-1']", text: event.fetch("title")
    assert_not_includes response.body, "<html"
    assert_select "main, h1, script", count: 0
    assert_includes response.body, "&lt;script&gt;"
    assert_select "a[data-turbo-frame='_top'][href=?]", contact_path
    assert_equal "no-store", response.headers["Cache-Control"]
    assert_equal [ "/public/v1/events/#{event.fetch('id')}" ], @requests.map { |uri, _headers| uri.path }
  end

  test "a cancelled modal warns the visitor and omits the visit invitation" do
    event = fixture("events").fetch("events").last
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => event })
    using_feed { get event_path(event.fetch("id")), headers: { "Turbo-Frame" => "event-details" } }
    assert_response :success
    assert_select "turbo-frame .event-notice", text: "This event has been cancelled."
    assert_select "a[href=?]", visit_path, count: 0
    assert_select "a[href=?]", contact_path
  end

  test "withdrawn and unavailable events return errors inside the modal frame" do
    @replies << publisher_response(nil, status: 404)
    using_feed { get event_path("withdrawn"), headers: { "Turbo-Frame" => "event-details" } }
    assert_response :not_found
    assert_select "turbo-frame#event-details h2", text: "This event is no longer available."
    assert_not_includes response.body, "<html"
    assert_select "main", count: 0
    assert_select "button", count: 0
    assert_equal "no-store", response.headers["Cache-Control"]
    assert_includes response.headers["X-Robots-Tag"], "noindex"

    @replies << Publishing::Unavailable.new("offline")
    using_feed { get event_path("unavailable"), headers: { "Turbo-Frame" => "event-details" } }
    assert_response :service_unavailable
    assert_select "turbo-frame#event-details h2", text: "Event details are temporarily unavailable."
    assert_not_includes response.body, "<html"
    assert_select "main", count: 0
    assert_select "button[data-action='event-dialog#retry']", text: "Try again"
    assert_equal "10", response.headers["Retry-After"]
    assert_equal "no-store", response.headers["Cache-Control"]
    assert_includes response.headers["X-Robots-Tag"], "noindex"
  end

  test "content expiring during a modal request is replaced with a matching error frame" do
    event = fixture("events").fetch("events").first
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => event })
    content = PublicContent.new(client: @client)
    find_event = content.method(:find_event!)
    expiring_read = lambda do |id|
      result = find_event.call(id)
      @now += 301
      result
    end
    content.stub(:find_event!, expiring_read) do
      PublicContent.stub(:new, content) do
        get event_path(event.fetch("id")), headers: { "Turbo-Frame" => "event-details" }
      end
    end
    assert_response :service_unavailable
    assert_select "turbo-frame#event-details h2", text: "Event details are temporarily unavailable."
    assert_not_includes response.body, "<html"
    assert_select "main", count: 0
    assert_not_includes response.body, event.fetch("title")
    assert_equal "10", response.headers["Retry-After"]
    assert_includes response.headers["X-Robots-Tag"], "noindex"
  end

  test "first visit shows every answer and contact omits unavailable channels without publisher reads" do
    using_feed do
      get visit_path
      assert_response :success
      assert_select ".launch-faq-card h2", count: 5
      assert_select "details, summary", count: 0
      assert_includes response.body, "without arranging it first"

      Rails.configuration.x.stub(:public_contact_email, "") do
        Rails.configuration.x.stub(:public_contact_phone, "") do
          get contact_path
          assert_response :success
          assert_select "a[href^='mailto:'], a[href^='tel:']", count: 0
          assert_select "address", text: /PO Box 11/
          assert_includes response.body, "Email and phone contact details aren’t available"
        end
      end
    end
    assert_empty @requests
  end
end
