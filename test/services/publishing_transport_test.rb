require "test_helper"
require "socket"

class PublishingTransportTest < ActiveSupport::TestCase
  test "real HTTP response preserves authentication status headers and body" do
    with_response("2") do |uri, requests|
      response = Publishing::Transport.new.call(uri, "Authorization" => "Bearer synthetic-website-token")
      assert_equal 200, response.status
      assert_equal "application/json", response.headers["content-type"]
      assert_equal "{}", response.body
      assert_includes requests.pop, "Authorization: Bearer synthetic-website-token\r\n"
    end
  end

  test "malformed response lengths become publishing unavailability" do
    [ "2, 3", "invalid", "" ].each do |length|
      with_response(length) do |uri, _requests|
        error = assert_raises(Publishing::Unavailable) do
          Publishing::Transport.new.call(uri, {})
        end
        assert_equal "Net::HTTPHeaderSyntaxError", error.message
      end
    end
  end

  private

  def with_response(length)
    server = TCPServer.new("127.0.0.1", 0)
    requests = Queue.new
    worker = Thread.new do
      socket = server.accept
      headers = +""
      while (line = socket.gets) && line != "\r\n"
        headers << line
      end
      requests << headers
      socket.write("HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: #{length}\r\nConnection: close\r\n\r\n{}")
    ensure
      socket&.close
    end
    yield URI("http://127.0.0.1:#{server.addr[1]}/synthetic"), requests
  ensure
    worker&.kill
    worker&.join
    server&.close
  end
end
