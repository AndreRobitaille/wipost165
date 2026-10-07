require "test_helper"
require_relative "../support/publishing_helpers"

# These responses simulate publisher transitions; they do not perform editorial writes.
class PublishingLifecycleTest < ActiveSupport::TestCase
  include PublishingHelpers

  setup { build_client }

  test "rotation replaces featured selection while a published detail remains readable" do
    member = fixture("featured")["members"].first
    @replies << publisher_response(fixture("featured"))
    assert_equal [ member["id"] ], @client.featured.map { |person| person["id"] }

    @now += 301
    @replies << publisher_response(fixture("featured").merge("members" => []), headers: { "etag" => '"rotated"' })
    assert_empty @client.featured
    @replies << publisher_response({ "schema_version" => 1, "member" => member })
    assert_equal member, @client.story(member["id"])
  end

  test "obsolete portrait clears cached story and selection so the replacement can be fetched" do
    member = fixture("featured")["members"].first
    @replies << publisher_response(fixture("featured"))
    @client.featured
    @replies << publisher_response({ "schema_version" => 1, "member" => member })
    @client.story(member["id"])

    old_revision = member["portrait"]["revision"]
    @replies << publisher_response(nil, status: 404)
    assert_raises(Publishing::NotFound) do
      @client.portrait(id: member["id"], revision: old_revision, size: "large")
    end

    member["story"] = "Updated synthetic introduction."
    member["portrait"]["revision"] = "replacement"
    member["portrait"]["variants"].each { |variant| variant["url"].sub!(old_revision, "replacement") }
    @replies << publisher_response({ "schema_version" => 1, "member" => member }, headers: { "etag" => '"updated"' })
    assert_equal member, @client.story(member["id"])
    assert_nil @requests.last.last["If-None-Match"]
    @replies << publisher_response(fixture("featured").merge("members" => [ member ]))
    assert_equal "replacement", @client.featured.first["portrait"]["revision"]
    @replies << portrait_response
    assert_equal portrait_bytes, @client.portrait(id: member["id"], revision: "replacement", size: "large")
    assert_includes @requests.last.first.path, "/portrait/replacement/large.webp"
  end

  test "a moved event replaces the old interval without making its detail unavailable" do
    from = Date.new(2026, 10, 1)
    to = Date.new(2026, 11, 1)
    @replies << publisher_response(fixture("events"))
    assert_equal 2, @client.events(from: from, to: to)["events"].size

    @now += 301
    @replies << publisher_response(fixture("events").merge("events" => []), headers: { "etag" => '"empty-october"' })
    assert_empty @client.events(from: from, to: to)["events"]
    assert_equal '"revision-1"', @requests.last.last["If-None-Match"]

    moved = fixture("events")["events"].first.merge("starts_at" => "2026-11-03T18:00:00-06:00")
    november = fixture("events").merge("from" => "2026-11-01", "to" => "2026-12-01", "events" => [ moved ])
    @replies << publisher_response(november)
    assert_equal [ moved ], @client.events(from: to, to: Date.new(2026, 12, 1))["events"]
    @replies << publisher_response({ "schema_version" => 1, "timezone" => "America/Chicago", "event" => moved })
    assert_equal moved, @client.event(moved["id"])["event"]
    assert_empty @client.events(from: from, to: to)["events"]
    assert_equal 4, @requests.size
  end

  test "cancellation replaces an active detail and later withdrawal evicts the cached interval" do
    event = fixture("events")["events"].first
    detail = { "schema_version" => 1, "timezone" => "America/Chicago", "event" => event }
    @replies << publisher_response(detail)
    assert_not @client.event(event["id"])["event"]["cancelled"]

    @now += 301
    event["cancelled"] = true
    @replies << publisher_response(detail, headers: { "etag" => '"cancelled"' })
    assert @client.event(event["id"])["event"]["cancelled"]
    @now += 250
    from, to = Date.new(2026, 10, 1), Date.new(2026, 11, 1)
    @replies << publisher_response(fixture("events").merge("events" => [ event ]))
    assert_equal [ event ], @client.events(from: from, to: to)["events"]

    @now += 51
    @replies << publisher_response(nil, status: 404)
    assert_raises(Publishing::NotFound) { @client.event(event["id"]) }
    assert_equal '"cancelled"', @requests.last.last["If-None-Match"]
    @replies << publisher_response(fixture("events").merge("events" => []))
    assert_empty @client.events(from: from, to: to)["events"]
    assert_nil @requests.last.last["If-None-Match"]
  end

  test "equal timed ends are points at the inclusive lower but not the exclusive upper boundary" do
    from, to = Date.new(2026, 11, 1), Date.new(2026, 11, 2)
    event = fixture("events")["events"].first.merge(
      "starts_at" => "2026-11-01T00:00:00-05:00", "ends_at" => "2026-11-01T00:00:00-05:00")
    data = fixture("events").merge("from" => from.to_s, "to" => to.to_s, "events" => [ event ])
    @replies << publisher_response(data)
    assert_equal [ event ], @client.events(from: from, to: to)["events"]

    @now += 301
    event.merge!("starts_at" => "2026-11-02T00:00:00-06:00", "ends_at" => "2026-11-02T00:00:00-06:00")
    @replies << publisher_response(data)
    assert_raises(Publishing::Unavailable) { @client.events(from: from, to: to) }
  end
end
