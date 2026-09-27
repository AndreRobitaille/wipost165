require "test_helper"
require "minitest/mock"

class ComingSoonTest < ActionDispatch::IntegrationTest
  setup do
    @coming_soon = Rails.configuration.x.public_site_coming_soon
    Rails.configuration.x.public_site_coming_soon = true
  end

  teardown { Rails.configuration.x.public_site_coming_soon = @coming_soon }

  test "public routes show only the holding page without contacting the publisher" do
    Publishing::Client.stub(:new, -> { raise "Coming soon must not use the publisher" }) do
      %w[/ /events /events/example /people/example /visit /about /contact /membership /veteran-help].each do |path|
        get path
        assert_response :success
        assert_select "h1", "Website coming soon."
        assert_select 'a[href="https://members.wipost165.org/"]', count: 1
        assert_select "img", count: 0
        assert_equal "no-store", response.headers["Cache-Control"]
      end
    end
  end

  test "health endpoint remains available independently of the holding page" do
    get "/up"
    assert_response :success
    assert_not_includes response.body, "Website coming soon."
  end
end
