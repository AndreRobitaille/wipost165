require "test_helper"
require "minitest/mock"
require_relative "../support/publishing_helpers"

class PortraitsTest < ActionDispatch::IntegrationTest
  include PublishingHelpers

  setup do
    build_client
    @edition = Rails.configuration.x.public_site_edition
    Rails.configuration.x.public_site_edition = "v2"
  end

  teardown { Rails.configuration.x.public_site_edition = @edition }

  def portrait_path
    published_portrait_path(id: "story_example_avery", revision: "portrait_example_2", size: "small")
  end

  test "GET and HEAD serve authenticated publisher images without exposing credentials or caching in browsers" do
    @replies << portrait_response
    Publishing::Client.stub(:new, @client) do
      get portrait_path
      assert_response :success
      assert_equal "image/webp", response.media_type
      assert_equal portrait_bytes, response.body.b
      assert_equal "no-store", response.headers["Cache-Control"]
      assert_not response.headers.key?("Authorization")
      assert_not response.headers.key?("Set-Cookie")
      head portrait_path
      assert_response :success
      assert_empty response.body
      assert_equal "no-store", response.headers["Cache-Control"]
    end
    assert_equal 1, @requests.size
  end

  test "missing portrait and revoked website access return empty no-store errors" do
    Publishing::Client.stub(:new, @client) do
      @replies << publisher_response(nil, status: 404)
      get portrait_path
      assert_response :not_found
      assert_empty response.body
      assert_equal "no-store", response.headers["Cache-Control"]
      @replies << publisher_response(nil, status: 401)
      get portrait_path
      assert_response :service_unavailable
      assert_empty response.body
      assert_equal "no-store", response.headers["Cache-Control"]
      assert_equal "10", response.headers["Retry-After"]
    end
  end

  test "invalid variants and coming-soon mode do not fetch portraits" do
    old_coming_soon = Rails.configuration.x.public_site_coming_soon
    Publishing::Client.stub(:new, -> { raise "Publisher must not be contacted" }) do
      get "/people/story/portrait/revision/original.webp"
      assert_response :not_found
      Rails.configuration.x.public_site_coming_soon = true
      get portrait_path
      assert_response :not_found
      assert_equal "no-store", response.headers["Cache-Control"]
    end
  ensure
    Rails.configuration.x.public_site_coming_soon = old_coming_soon
  end
end
