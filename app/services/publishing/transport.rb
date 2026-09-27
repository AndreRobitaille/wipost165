require "net/http"
require "timeout"

module Publishing
  class Transport
    def call(uri, headers)
      Timeout.timeout(4) do
        http = Net::HTTP.new(uri.host, uri.port, nil)
        http.use_ssl = uri.scheme == "https"
        http.open_timeout = 1
        http.read_timeout = 2
        http.write_timeout = 2
        http.max_retries = 0
        http.start do
          request = Net::HTTP::Get.new(uri.request_uri, headers)
          http.request(request) do |response|
            body = +"".b
            response.read_body do |chunk|
              body << chunk
              raise Unavailable, "Publisher response too large" if body.bytesize > 2.megabytes
            end
            return Response.new(status: response.code.to_i, headers: response.to_hash.transform_values(&:first), body: body)
          end
        end
      end
    rescue IOError, SystemCallError, Timeout::Error, OpenSSL::SSL::SSLError, Net::HTTPBadResponse => error
      raise Unavailable, error.class.name
    end
  end
end
