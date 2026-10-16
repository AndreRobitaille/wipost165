require "test_helper"

class PublisherCheckTest < ActiveSupport::TestCase
  test "V1 checks events without requesting people or portraits" do
    client = Minitest::Mock.new
    events = 11.times.map { |i| { "id" => "event-#{i}" } }
    client.expect(:events, { "events" => events }, from: Date.current, to: Date.current + 90)
    events.first(10).each { |event| client.expect(:event, event, [ event.fetch("id") ]) }

    check_with(client, "v1")
    client.verify
  end

  test "V2 still checks stories and portrait variants" do
    client = Minitest::Mock.new
    person = { "id" => "person-1", "portrait" => { "revision" => "rev-1", "variants" => [ { "size" => "card" } ] } }
    client.expect(:featured, [ person ])
    client.expect(:events, { "events" => [] }, from: Date.current, to: Date.current + 90)
    client.expect(:story, person, [ "person-1" ])
    client.expect(:portrait, "image", id: "person-1", revision: "rev-1", size: "card")

    check_with(client, "v2")
    client.verify
  end

  private

  def check_with(client, edition)
    Rails.configuration.x.stub(:public_site_edition, edition) do
      Publishing::Client.stub(:new, client) do
        capture_io { load Rails.root.join("bin/publisher-check") }
      end
    end
  end
end
