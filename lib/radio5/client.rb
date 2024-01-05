# frozen_string_literal: true

module Radio5
  class Client
    include Utils
    include Validator
    include Users
    include Countries
    include Islands
    include Tracks

    class ApiError < StandardError; end

    attr_accessor :open_timeout, :read_timeout, :write_timeout, :proxy_url, :debug_output

    def initialize(open_timeout: nil, read_timeout: nil, write_timeout: nil, proxy_url: nil, debug_output: nil)
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      @write_timeout = write_timeout
      @proxy_url = proxy_url
      @debug_output = debug_output
    end

    def api
      Http.new(
        host: "radiooooo.com",
        port: 443,
        open_timeout: open_timeout,
        read_timeout: read_timeout,
        write_timeout: write_timeout,
        proxy_url: proxy_url,
        debug_output: debug_output
      )
    end
  end
end
