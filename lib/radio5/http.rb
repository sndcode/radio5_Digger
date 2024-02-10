# frozen_string_literal: true

require "net/http"
require "openssl"
require "uri"

module Radio5
  class Http
    DEFAULT_OPEN_TIMEOUT = 10 # seconds
    DEFAULT_READ_TIMEOUT = 10 # seconds
    DEFAULT_WRITE_TIMEOUT = 10 # seconds
    DEFAULT_PROXY_URL = nil
    DEFAULT_MAX_RETRIES = 3
    DEFAULT_DEBUG_OUTPUT = nil

    DEFAULT_HEADERS = {
      "Content-Type" => "application/json; charset=utf-8",
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }.freeze

    RETRIABLE_ERRORS = [
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::ETIMEDOUT,
      Net::OpenTimeout,
      Net::ReadTimeout,
      Net::WriteTimeout,
      OpenSSL::SSL::SSLError
    ].freeze

    attr_reader :host, :port, :open_timeout, :read_timeout, :write_timeout, :proxy_url, :max_retries, :debug_output, :http_client

    def initialize(
      host:,
      port:,
      open_timeout: nil,
      read_timeout: nil,
      write_timeout: nil,
      proxy_url: nil,
      max_retries: nil,
      debug_output: nil
    )
      @host          = host
      @port          = port
      @open_timeout  = open_timeout  || DEFAULT_OPEN_TIMEOUT
      @read_timeout  = read_timeout  || DEFAULT_READ_TIMEOUT
      @write_timeout = write_timeout || DEFAULT_WRITE_TIMEOUT
      @proxy_url     = proxy_url     || DEFAULT_PROXY_URL
      @max_retries   = max_retries   || DEFAULT_MAX_RETRIES
      @debug_output  = debug_output  || DEFAULT_DEBUG_OUTPUT

      @http_client = Net::HTTP.new(@host, @port, proxy_uri&.host, proxy_uri&.port, proxy_uri&.user, proxy_uri&.password)

      @http_client.tap do |c|
        c.use_ssl       = @port == 443
        c.open_timeout  = @open_timeout
        c.read_timeout  = @read_timeout
        c.write_timeout = @write_timeout

        c.set_debug_output(@debug_output)
      end
    end

    def proxy_uri
      @proxy_uri ||= parse_proxy_uri
    end

    def request(http_method_class, path, query_params, body, headers)
      request = build_request(http_method_class, path, query_params, body, headers)
      make_request(request)
    end

    private

    def parse_proxy_uri
      return if proxy_url.nil?

      case uri = URI(proxy_url)
      when URI::HTTP
        uri
      else
        raise ArgumentError, "Invalid proxy URL: #{proxy_url.inspect}, parsed URI: #{uri.inspect}"
      end
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
      http_client.request(request)
    rescue *RETRIABLE_ERRORS => error
      if retries < max_retries
        make_request(request, retries: retries + 1)
      else
        raise error
      end
    end
  end
end
