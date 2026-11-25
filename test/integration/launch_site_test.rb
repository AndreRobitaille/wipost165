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

  test "calendar and map links use the published occasion on direct pages and in the dialog" do
    event = fixture("events").fetch("events").first.merge(
      "title" => "Brat fry, lunch & music", "location" => "Riverside Park, 1 Main St, Two Rivers, WI",
      "ends_at" => "2026-10-03T21:00:00-05:00")
    path = event_path(event["id"])
    url = "https://wipost165.org#{path}"
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => event })

    travel_to Time.utc(2026, 10, 3, 23, 30) do
      using_feed do
        [ {}, { "Turbo-Frame" => "event-details" } ].each do |headers|
          get path, headers: headers
          assert_select ".event-details[data-event-device=desktop]"
          assert_select ".event-when details:not([open]) > summary span", text: "Add to calendar"
          assert_select ".event-calendar-picker a[href=?][data-turbo=false][target=_top]:not([download])", event_calendar_path(event["id"]) do
            assert_select "span", text: "Apple Calendar"
            assert_select ".event-calendar-hint", text: /open it in Calendar/
          end
          assert_select ".event-calendar a[href^='https://calendar.google.com'] .event-calendar-hint", text: "Sign in to Google to save"
          google = css_select(".event-calendar a").last
          google_url = URI(google["href"])
          query = Rack::Utils.parse_query(google_url.query)
          assert_equal [ "calendar.google.com", "/calendar/render", "_blank" ], [ google_url.host, google_url.path, google["target"] ]
          assert_equal [ event["title"], "20261003T230000Z/20261004T020000Z", event["location"], url ],
            query.values_at("text", "dates", "location", "details")
          map = URI(css_select("a.event-map").sole["href"])
          assert_select ".event-map[aria-label=?] .event-tool", "View on map — #{event["location"]}", text: "View on map"
          assert_equal "www.google.com", map.host
          assert_equal({ "api" => "1", "query" => event["location"] }, Rack::Utils.parse_query(map.query))
        end
        get event_calendar_path(event["id"])
        assert_response :success
        assert_equal "text/calendar", response.media_type
        assert_equal "no-store", response.headers["Cache-Control"]
        assert_match(/inline;.*\.ics/, response.headers["Content-Disposition"])
        saved = Icalendar::Calendar.parse(response.body).sole.events.sole
        assert_equal [ event["title"], event["location"], url, url ], [ saved.summary, saved.location, saved.url, saved.uid ].map(&:to_s)
        assert_equal "20261003T230000Z", saved.dtstart.value_ical
        assert_equal "20261004T020000Z", saved.dtend.value_ical
      end
    end
  end

  test "mobile calendar and map actions hand off the same published event in the page and dialog" do
    event = fixture("events").fetch("events").first.merge("location" => "Main St & River Rd")
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => event })
    path = event_path(event["id"])
    query = "Main%20St%20%26%20River%20Rd"

    travel_to Time.utc(2026, 10, 1) do
      using_feed do
        [
          [ { "User-Agent" => "iPhone" }, "ios", "https://maps.apple.com/?q=#{query}" ],
          [ { "Sec-CH-UA-Platform" => '"Android"', "Turbo-Frame" => "event-details" }, "android", "geo:0,0?q=#{query}" ]
        ].each do |headers, device, map|
          get path, headers: headers
          assert_response :success
          assert_select ".event-details[data-event-device=?]", device
          assert_select ".event-native-calendar[href=?][target=_top][type='text/calendar'][data-turbo=false]", event_calendar_path(event["id"]), text: "Add to calendar"
          assert_select "a.event-map[href=?]", map, count: 1
          assert_select ".event-location details", count: 0
        end
      end
    end
  end

  test "all-day and point events preserve their timing and literal text" do
    timed, all_day = fixture("events").fetch("events")
    timed["title"] = "Back\\nine; " + "café, " * 18 + "\rSecond line"
    travel_to Time.utc(2026, 10, 1) do
      [ timed, all_day.merge("cancelled" => false) ].each do |event|
        @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => event })
        using_feed { get event_calendar_path(event["id"]) }
        assert_response :success
        saved = Icalendar::Calendar.parse(response.body).sole.events.sole
        if event["all_day"]
          assert_includes response.body, "DTSTART;VALUE=DATE:20261010\r\n"
          assert_includes response.body, "DTEND;VALUE=DATE:20261012\r\n"
        else
          assert_equal timed["title"].tr("\r", "\n"), saved.summary.to_s
          assert_nil saved.dtend
          assert_includes saved.description.to_s, "End time not specified."
        end
      end
    end
  end

  test "unconfirmed and remote locations are readable without a map destination" do
    event = fixture("events").fetch("events").first
    [ nil, "Location TBD", "N/A", "Microsoft Teams", "https://meet.example/room" ].each_with_index do |place, i|
      record = event.merge("id" => "place-#{i}", "location" => place)
      @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => record })
      using_feed { get event_path(record["id"]), headers: { "Turbo-Frame" => "event-details" } }
      assert_select ".event-location", text: place || "To be confirmed"
      assert_select ".event-location a", count: 0
    end
  end

  test "unavailable, withheld, cancelled, past, and preview events cannot be downloaded" do
    event = fixture("events").fetch("events").first
    travel_to Time.utc(2026, 10, 3, 23, 30) do
      [ { "id" => "past", "starts_at" => event.fetch("starts_at") },
        { "id" => "cancelled", "cancelled" => true },
        { "id" => "withheld", "category" => "honor_funeral" } ].each do |changes|
        record = event.merge("starts_at" => "2026-10-04T17:00:00-05:00").merge(changes)
        @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => record })
        using_feed { get event_calendar_path(record["id"]) }
        assert_response :not_found
        assert_empty response.body
      end
      @replies << publisher_response(nil, status: 404)
      using_feed { get event_calendar_path("withdrawn") }
      assert_response :not_found
      @replies << Publishing::Unavailable.new("offline")
      using_feed { get event_calendar_path("unavailable") }
      assert_response :service_unavailable
      Rails.configuration.x.public_site_preview = true
      using_feed { get event_calendar_path("example-gathering") }
      assert_response :not_found
    end
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
      assert_select ".launch-harbor img[alt*='Illustration of Two Rivers'][width='1536'][height='1024'][loading='eager'][fetchpriority='high']", count: 1
      assert_select ".launch-harbor img[src*='two-rivers-harbor-illustration'][srcset*='480w'][srcset*='768w'][srcset*='1024w'][srcset*='1200w'][srcset*='1536w'][sizes='(max-width: 900px) 100vw, 900px']"
      assert_select "link[rel='preload'][as='image'][type='image/webp'][imagesrcset][imagesizes='(max-width: 900px) 100vw, 900px'][fetchpriority='high']", count: 1
      assert_select "link[rel='stylesheet']", count: 1
      assert_select "link[rel='stylesheet'][href*='launch']", count: 1
      assert_select "link[rel='stylesheet'][href*='company'], link[rel='stylesheet'][href*='post_pages'], link[rel='stylesheet'][href*='why_legion'], link[rel='stylesheet'][href*='application']", count: 0
      assert_select ".launch-brand source[type='image/webp'][srcset*='1x'][srcset*='2x'][srcset*='legion-white-408'][srcset*='3x']", count: 1
      assert_select ".launch-brand img[src*='legion-white'][width='1500'][height='413']", count: 1
      assert_select "link[rel='icon'][href='/favicon-96x96.png'][sizes='96x96'][type='image/png']", count: 1
      assert_select "link[rel='icon'][href='/favicon.ico']", count: 1
      assert_select "link[rel='apple-touch-icon'][sizes='180x180']", count: 1
      assert_select "link[rel='manifest'][href='/site.webmanifest']", count: 1
      assert_select 'meta[property="og:title"][content=?]', PublicSiteHelper::DOCUMENT_TITLE
      assert_select 'img[src*="portrait"], img[src*="people"]', count: 0
      assert_select '.launch-harbor a[href="https://creativecommons.org/licenses/by-sa/4.0/"]'
      assert_not_includes response.body, "?person="
      assert_equal 1, @requests.size
      assert_equal "/public/v1/events", @requests.first.first.path
      assert_nil response.headers["X-Robots-Tag"]
      assert_select 'link[rel="canonical"][href="https://wipost165.org/"]'
      get css_select("link[rel='stylesheet']").first["href"]
      assert_includes response.body, "woff2"
      assert_includes response.body, "font-display: swap"
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
      assert_select 'link[rel="canonical"][href="https://wipost165.org/people/story_example_avery"]'
      assert_select 'meta[property^="og:"], meta[name^="twitter:"]', count: 0
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

  test "interior launch pages keep their own stylesheets and skip the harbor preload" do
    using_feed do
      get why_legion_path
      assert_response :success
      assert_select "link[rel=stylesheet][href*=launch]", count: 1
      assert_select "link[rel=stylesheet][href*=why_legion]", count: 1
      assert_select "link[rel=stylesheet][href*=post_pages], link[rel=stylesheet][href*=company]", count: 0
      assert_select "link[rel=preload][as=image]", count: 0

      get about_path
      assert_response :success
      assert_select "link[rel=stylesheet][href*=launch]", count: 1
      assert_select "link[rel=stylesheet][href*=post_pages]", count: 1
      assert_select "link[rel=stylesheet][href*=why_legion], link[rel=stylesheet][href*=company]", count: 0
      assert_select "link[rel=preload][as=image]", count: 0
    end
    assert_empty @requests
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
