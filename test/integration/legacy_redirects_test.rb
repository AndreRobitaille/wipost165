require "test_helper"

class LegacyRedirectsTest < ActionDispatch::IntegrationTest
  LEGACY_PATHS = {
    "/home" => "/",
    "/contact-us" => "/contact",
    "/about-post-165" => "/about"
  }.freeze

  test "legacy paths permanently redirect to the live pages and keep the query string" do
    LEGACY_PATHS.each do |legacy, destination|
      get legacy
      assert_response :moved_permanently
      assert_redirected_to destination

      get legacy, params: { ref: "bookmark" }
      assert_response :moved_permanently
      assert_redirected_to "#{destination}?ref=bookmark"
      assert_equal "http://www.example.com#{destination}?ref=bookmark", response.headers["Location"]

      head legacy
      assert_response :moved_permanently
      assert_redirected_to destination

      get legacy, params: { host: "evil.example" }
      assert_response :moved_permanently
      assert_equal "http://www.example.com#{destination}?host=evil.example", response.headers["Location"]
    end
  end

  test "each legacy redirect lands on a successful page" do
    LEGACY_PATHS.each do |legacy, destination|
      get legacy
      follow_redirect!
      assert_response :success
      assert_equal destination, request.path
    end
  end

  test "nearby unknown paths stay not found and the live pages are not redirected" do
    %w[/homes /contactus /about-post /about-post-1650 /home.html].each do |path|
      get path
      assert_response :not_found, path
      assert_nil response.headers["Location"]
    end

    get "/contact"
    assert_response :success
    get "/about"
    assert_response :success
    get "/"
    assert_response :success

    post "/home"
    assert_response :not_found
    assert_nil response.headers["Location"]
  end
end
