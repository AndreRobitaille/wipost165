require "test_helper"

class HealthTest < ActionDispatch::IntegrationTest
  test "the application boots and responds to health checks" do
    get rails_health_check_url

    assert_response :success
    assert_equal "text/html", response.media_type
  end
end
