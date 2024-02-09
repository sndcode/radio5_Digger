# frozen_string_literal: true

module Radio5
  class Client
    include Utils
    include Validations
    include Users
    include Countries
    include Islands
    include Tracks

    attr_accessor :open_timeout, :read_timeout, :write_timeout, :proxy_url, :max_retries, :debug_output

    def initialize(
      open_timeout: Http::DEFAULT_OPEN_TIMEOUT,
      read_timeout: Http::DEFAULT_READ_TIMEOUT,
      write_timeout: Http::DEFAULT_WRITE_TIMEOUT,
      proxy_url: Http::DEFAULT_PROXY_URL,
      max_retries: Http::DEFAULT_MAX_RETRIES,
      debug_output: Http::DEFAULT_DEBUG_OUTPUT
    )
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      @write_timeout = write_timeout
      @proxy_url = proxy_url
      @max_retries = max_retries
      @debug_output = debug_output
    end

    def api
      @api ||= Api.new(client: self)
    end

    def decades
      Constants::DECADES
    end

    def moods
      Constants::MOODS
    end
  end
end
