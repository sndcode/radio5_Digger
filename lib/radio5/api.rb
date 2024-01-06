# frozen_string_literal: true

module Radio5
  class Api
    class Error < StandardError; end
    class TrackNotFound < Error; end
    class MatchingTrackNotFound < Error; end
    class UnexpectedResponse < StandardError; end

    HOST = "radiooooo.com"
    PORT = 443

    attr_reader :client

    def initialize(client:)
      @client = client
    end

    def get(path, query_params: {}, headers: {})
      request(Net::HTTP::Get, path, query_params, nil, headers)
    end

    def post(path, query_params: {}, body: nil, headers: {})
      request(Net::HTTP::Post, path, query_params, body, headers)
    end

    private

    def request(http_method_class, path, query_params, body, headers)
      http = create_http
      response = http.request(http_method_class, path, query_params, body, headers)

      case response.code
      when "200", "400"
        json = Utils.parse_json(response.body)

        case json
        in error: "No track with this id"
          raise TrackNotFound
        in error: "No track for this selection"
          raise MatchingTrackNotFound
        in error: other_error
          raise Error, other_error
        else
          [response, json]
        end
      else
        raise UnexpectedResponse, "code: #{response.code.inspect}, body: #{response.body.inspect}"
      end
    end

    # rubocop:disable Layout/HashAlignment
    def create_http
      Http.new(
        host:          HOST,
        port:          PORT,
        open_timeout:  client.open_timeout,
        read_timeout:  client.read_timeout,
        write_timeout: client.write_timeout,
        proxy_url:     client.proxy_url,
        debug_output:  client.debug_output
      )
    end
    # rubocop:enable Layout/HashAlignment
  end
end
