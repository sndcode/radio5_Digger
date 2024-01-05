# frozen_string_literal: true

require "net/http"
require "openssl"
require "uri"

module Radio5
  class Http
    class NotOkResponseError < StandardError; end

    DEFAULT_HOST = "radiooooo.com"
    DEFAULT_PORT = 443
    DEFAULT_OPEN_TIMEOUT = 10 # seconds
    DEFAULT_READ_TIMEOUT = 10 # seconds
    DEFAULT_WRITE_TIMEOUT = 10 # seconds
    DEFAULT_DEBUG_OUTPUT = File.open(File::NULL, "w")
    DEFAULT_MAX_RETRIES = 3
    DEFAULT_HEADERS = {
      "Content-Type" => "application/json; charset=utf-8",
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }
    RETRIABLE_ERRORS = [
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::ETIMEDOUT,
      Net::OpenTimeout,
      Net::ReadTimeout,
      Net::WriteTimeout,
      OpenSSL::SSL::SSLError
    ]

    attr_reader :max_retries

    # rubocop:disable Layout/ExtraSpacing
    def initialize(
      host: DEFAULT_HOST,
      port: DEFAULT_PORT,
      open_timeout: DEFAULT_OPEN_TIMEOUT,
      read_timeout: DEFAULT_READ_TIMEOUT,
      write_timeout: DEFAULT_WRITE_TIMEOUT,
      proxy_url: nil,
      max_retries: DEFAULT_MAX_RETRIES,
      debug_output: DEFAULT_DEBUG_OUTPUT
    )
      # @host          = host
      # @port          = port
      # @open_timeout  = open_timeout
      # @read_timeout  = read_timeout
      # @write_timeout = write_timeout
      # @proxy_url     = proxy_url
      # @debug_output  = debug_output

      proxy_uri = parse_proxy_uri(proxy_url)
      @max_retries = max_retries

      @http = Net::HTTP.new(host, port, proxy_uri&.host, proxy_uri&.port, proxy_uri&.user, proxy_uri&.pass)

      @http.tap do |c|
        c.use_ssl       = port == 443
        c.open_timeout  = open_timeout
        c.read_timeout  = read_timeout
        c.write_timeout = write_timeout

        c.set_debug_output(debug_output)
      end
    end
    # rubocop:enable Layout/ExtraSpacing

    def get(path, query_params: {}, headers: {})
      request(Net::HTTP::Get, path, query_params, nil, headers)
    end

    def post(path, query_params: {}, body: nil, headers: {})
      request(Net::HTTP::Post, path, query_params, body, headers)
    end

    private

    def parse_proxy_uri(proxy_url)
      return if proxy_url.nil?

      proxy_uri = URI(proxy_url)

      unless @proxy_uri.is_a?(URI::HTTP)
        raise ArgumentError, "Invalid proxy URL: #{@proxy_uri}"
      end

      proxy_uri
    end

    def request(http_method_class, path, query_params, body, headers)
      request = build_request(http_method_class, path, query_params, body, headers)
      make_request(request)
    end

    def build_request(http_method_class, path, query_params, body, headers)
      path = add_query_params(path, query_params)

      request = http_method_class.new(path)
      add_body(request, body)
      add_headers(request, headers)

      request
    end

    def add_query_params(path, query_params)
      if query_params.empty?
        path
      else
        "#{path}?#{URI.encode_www_form(query_params)}"
      end
    end

    def add_body(request, body)
      request.body = body
    end

    def add_headers(request, headers)
      DEFAULT_HEADERS.merge(headers).each do |key, value|
        request.delete(key)
        request.add_field(key, value)
      end
    end

    def make_request(request, retries: 0)
      response = @http.request(request)

      if response.code != "200"
        raise NotOkResponseError, "code: #{response.code}, body: #{response.body}"
      end

      response
    rescue *RETRIABLE_ERRORS => error
      if retries < max_retries
        make_request(request, retries: retries + 1)
      else
        raise error
      end
    end
  end
end
