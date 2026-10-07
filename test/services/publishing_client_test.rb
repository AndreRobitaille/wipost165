require "test_helper"
require_relative "../support/publishing_helpers"

class PublishingClientTest < ActiveSupport::TestCase
  include PublishingHelpers

  setup { build_client }

  test "every origin request including revalidation authenticates with the website token" do
    @replies << publisher_response(fixture("featured"))
    @client.featured
    @now += 301
    @replies << publisher_response(nil, status: 304)
    @client.featured
    assert @requests.all? { |_uri, headers| headers["Authorization"] == "Bearer website-test-token" }
    assert @requests.all? { |uri, _headers| uri.query.nil? }
  end

  test "missing and malformed tokens fail before contacting the publisher or using cache" do
    @replies << publisher_response(fixture("featured"))
    @client.featured
    [ nil, "", "unsafe\r\nHeader: value" ].each do |token|
      client = Publishing::Client.new(token: token, cache: @cache, transport: @transport)
      assert_raises(Publishing::Unavailable) { client.featured }
    end
    assert_equal 1, @requests.size
  end

  test "a replacement credential cannot reuse another credential's cached content" do
    @replies << publisher_response(fixture("featured"))
    @client.featured
    replacement = Publishing::Client.new(token: "replacement-token", cache: @cache, transport: @transport, clock: -> { @now })
    @replies << publisher_response(nil, status: 401)
    assert_raises(Publishing::Unavailable) { replacement.featured }
    assert_equal 2, @requests.size
    assert_equal "Bearer replacement-token", @requests.last.last["Authorization"]
    assert_equal 1, @client.featured.size
  end

  test "authentication denial discards all cached access for that credential" do
    @replies << publisher_response(fixture("featured"))
    @client.featured
    @replies << publisher_response(nil, status: 401)
    assert_raises(Publishing::Unavailable) { @client.story("story_example_avery") }
    assert @client.expired?
    @replies << publisher_response(nil, status: 401)
    assert_raises(Publishing::Unavailable) { @client.featured }
    assert_equal 3, @requests.size
  end

  test "portraits authenticate cache privately and fail closed after expiry" do
    @replies << portrait_response(headers: { "age" => "240" })
    assert_equal portrait_bytes, @client.portrait(id: "story_example_avery", revision: "portrait_example_2", size: "large")
    assert_equal "Bearer website-test-token", @requests.last.last["Authorization"]
    assert_equal "image/webp", @requests.last.last["Accept"]
    @now += 59
    @client.portrait(id: "story_example_avery", revision: "portrait_example_2", size: "large")
    assert_equal 1, @requests.size
    @now += 2
    @replies << Publishing::Unavailable.new("offline")
    assert_raises(Publishing::Unavailable) { @client.portrait(id: "story_example_avery", revision: "portrait_example_2", size: "large") }
  end

  test "obsolete portrait revisions evict the corresponding cached page content" do
    @replies << publisher_response(fixture("featured"))
    @client.featured
    @replies << publisher_response(nil, status: 404)
    assert_raises(Publishing::NotFound) { @client.portrait(id: "story_example_avery", revision: "old", size: "large") }
    @replies << publisher_response(fixture("featured").merge("members" => []))
    assert_empty @client.featured
    assert_equal 3, @requests.size
  end

  test "portrait paths cannot request arbitrary destinations and image bodies are validated" do
    [ "../private", "https://elsewhere.example", "id?query=yes" ].each do |id|
      assert_raises(Publishing::NotFound) { @client.portrait(id: id, revision: "rev", size: "large") }
    end
    assert_raises(Publishing::NotFound) { @client.portrait(id: "id", revision: "rev", size: "original") }
    assert_empty @requests
    @replies << Publishing::Response.new(status: 200, headers: portrait_response.headers, body: "<html>error</html>")
    assert_raises(Publishing::Unavailable) { @client.portrait(id: "id", revision: "rev", size: "large") }
  end

  test "fresh cache saves requests and never renews the original freshness" do
    @replies << publisher_response(fixture("featured"))
    assert_equal "Avery", @client.featured.first["display_name"]
    @now += 240
    assert_equal 1, @client.featured.size
    assert_equal 1, @requests.size
    @now += 61
    @replies << Publishing::Unavailable.new("offline")
    assert_raises(Publishing::Unavailable) { @client.featured }
    assert @client.expired?
  end

  test "Age and network time reduce the five minute budget" do
    @replies << publisher_response(fixture("featured"), headers: { "age" => "240" })
    @client.featured
    @now += 59
    @client.featured
    assert_equal 1, @requests.size
    @now += 2
    @replies << publisher_response(fixture("featured"))
    assert_equal 1, @client.featured.size
    assert_equal 2, @requests.size
  end

  test "304 revalidates the exact cached representation with new date and cleared old age" do
    @replies << publisher_response(fixture("featured"), headers: { "age" => "250" })
    @client.featured
    @now += 51
    @replies << publisher_response(nil, status: 304)
    assert_equal 1, @client.featured.size
    assert_equal '"revision-1"', @requests.last.last["If-None-Match"]
    assert_equal "no-cache", @requests.last.last["Cache-Control"]
    @now += 249
    @client.featured
    assert_equal 2, @requests.size
  end

  test "unmatched or undated 304 cannot extend freshness" do
    @replies << publisher_response(nil, status: 304)
    assert_raises(Publishing::Unavailable) { @client.featured }
    @now += 11
    @replies << publisher_response(fixture("featured"))
    @client.featured
    @now += 301
    @replies << publisher_response(nil, status: 304, headers: { "date" => nil })
    assert_raises(Publishing::Unavailable) { @client.featured }
  end

  test "304 with a different or missing validator cannot renew cached content" do
    @replies << publisher_response(fixture("featured"))
    @client.featured
    @now += 301

    [ '"different-revision"', nil ].each do |etag|
      @replies << publisher_response(nil, status: 304, headers: { "etag" => etag })
      assert_raises(Publishing::Unavailable) { @client.featured }
      assert @client.expired?
      assert_equal '"revision-1"', @requests.last.last["If-None-Match"]
      @now += 11
    end

    @replies << publisher_response(fixture("featured").merge("members" => []), headers: { "etag" => '"revision-2"' })
    assert_empty @client.featured
  end

  test "304 can weakly match the validator sent for the cached representation" do
    @replies << publisher_response(fixture("featured"), headers: { "etag" => 'W/"revision-1"' })
    @client.featured
    @now += 301
    @replies << publisher_response(nil, status: 304)
    assert_equal "Avery", @client.featured.first["display_name"]
    assert_equal 'W/"revision-1"', @requests.last.last["If-None-Match"]
  end

  test "known withdrawal evicts featured collections as well as detail" do
    @replies << publisher_response(fixture("featured"))
    @client.featured
    @replies << publisher_response(nil, status: 404)
    assert_raises(Publishing::NotFound) { @client.story("story_example_avery") }
    @replies << publisher_response({ "schema_version" => 1, "complete" => true, "members" => [] })
    assert_empty @client.featured
    assert_equal 3, @requests.size
  end

  test "complete empty replacement and independently cached intervals" do
    @replies << publisher_response(fixture("events"))
    @client.events(from: Date.new(2026, 10, 1), to: Date.new(2026, 11, 1))
    empty = fixture("events").merge("from" => "2026-11-01", "to" => "2026-12-01", "events" => [])
    @replies << publisher_response(empty)
    assert_empty @client.events(from: Date.new(2026, 11, 1), to: Date.new(2026, 12, 1))["events"]
    assert_equal 2, @client.events(from: Date.new(2026, 10, 1), to: Date.new(2026, 11, 1))["events"].size
  end

  test "malformed and incomplete responses are unavailable never empty success" do
    variants = [ fixture("featured").merge("complete" => false), fixture("featured").merge("schema_version" => 2),
      fixture("featured").merge("members" => [ nil ]), fixture("featured").merge("members" => fixture("featured")["members"] * 4) ]
    variants.each do |data|
      @now += 11
      @replies << publisher_response(data)
      assert_raises(Publishing::Unavailable) { @client.featured }
    end
    @now += 11
    @replies << Publishing::Response.new(status: 200, headers: publisher_response.headers, body: "<html>not JSON</html>")
    assert_raises(Publishing::Unavailable) { @client.featured }
  end

  test "portrait URLs cannot redirect the visitor to another host or a private blob" do
    data = fixture("featured")
    data["members"].first["portrait"]["variants"].first["url"] = "https://evil.example/private-photo"
    @replies << publisher_response(data)
    assert_raises(Publishing::Unavailable) { @client.featured }
  end

  test "publisher errors and redirects are not followed or cached as empty content" do
    [ 301, 302, 404, 429, 503 ].each do |status|
      @now += 11
      @replies << publisher_response(nil, status: status)
      assert_raises(Publishing::Unavailable) { @client.featured }
    end
    assert_equal 5, @requests.size
  end

  test "invalid cache metadata and aged responses fail closed" do
    [ { "cache-control" => "no-store" }, { "cache-control" => "public, max-age=300" }, { "age" => "-1" }, { "age" => "301" },
      { "date" => "invalid" }, { "cache-control" => "max-age=300, max-age=600" } ].each do |headers|
      @now += 11
      @replies << publisher_response(fixture("featured"), headers: headers)
      assert_raises(Publishing::Unavailable) { @client.featured }
    end
  end

  test "null all-day end is valid and timed malformed fields are rejected" do
    data = fixture("events")
    data["events"].last["ends_on_exclusive"] = nil
    @replies << publisher_response(data)
    assert_equal 2, @client.events(from: Date.new(2026, 10, 1), to: Date.new(2026, 11, 1))["events"].size
    @now += 301
    data["events"].first["starts_at"] = "2026-10-03 18:00"
    @replies << publisher_response(data)
    assert_raises(Publishing::Unavailable) { @client.events(from: Date.new(2026, 10, 1), to: Date.new(2026, 11, 1)) }
  end

  test "detail identity mismatch is rejected" do
    @replies << publisher_response({ "schema_version" => 1, "member" => fixture("featured")["members"].first })
    assert_raises(Publishing::Unavailable) { @client.story("someone-else") }
  end

  test "origin and interval validation never permits arbitrary server-side URLs" do
    [ "http://members.wipost165.org", "https://user:pass@example.org", "https://example.org/api", "https://example.org?key=value" ].each do |origin|
      assert_raises(ArgumentError) { Publishing::Client.new(origin: origin) }
    end
    assert_raises(ArgumentError) { @client.events(from: Date.today, to: Date.today + 94) }
    assert_empty @requests
  end
  test "network delay counts against origin Age" do
    client = Publishing::Client.new(token: "website-test-token", cache: @cache, clock: -> { @now }, transport: lambda { |_uri, _headers|
      reply = publisher_response(fixture("featured"), headers: { "age" => "298" })
      @now += 4
      reply
    })
    assert_raises(Publishing::Unavailable) { client.featured }
  end

  test "publishing overlap excludes exact end boundary and handles DST local midnight" do
    data = fixture("events").merge("from" => "2026-11-01", "to" => "2026-11-02")
    event = data["events"].first
    event.merge!("starts_at" => "2026-10-31T23:00:00-05:00", "ends_at" => "2026-11-01T00:00:00-05:00")
    data["events"] = [ event ]
    @replies << publisher_response(data)
    assert_raises(Publishing::Unavailable) { @client.events(from: Date.new(2026, 11, 1), to: Date.new(2026, 11, 2)) }
    @now += 11
    event.merge!("starts_at" => "2026-11-01T23:30:00-06:00", "ends_at" => nil)
    @replies << publisher_response(data)
    assert_equal 1, @client.events(from: Date.new(2026, 11, 1), to: Date.new(2026, 11, 2))["events"].size
  end

  test "event ordering is deterministic and duplicate identities are rejected" do
    data = fixture("events")
    data["events"].reverse!
    @replies << publisher_response(data)
    assert_raises(Publishing::Unavailable) { @client.events(from: Date.new(2026, 10, 1), to: Date.new(2026, 11, 1)) }
    @now += 11
    members = fixture("featured")
    members["members"] *= 2
    @replies << publisher_response(members)
    assert_raises(Publishing::Unavailable) { @client.featured }
  end
end
