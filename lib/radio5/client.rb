# frozen_string_literal: true

module Radio5
  class Client
    include Utils
    include Validator
    include Users
    include Countries
    include Islands
    include Tracks

    attr_accessor :open_timeout, :read_timeout, :write_timeout, :proxy_url, :max_retries, :debug_output

    def initialize(
      open_timeout: nil,
      read_timeout: nil,
      write_timeout: nil,
      proxy_url: nil,
      max_retries: nil,
      debug_output: nil
    )
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      @write_timeout = write_timeout
      @max_retries = max_retries
      @proxy_url = proxy_url
      @debug_output = debug_output
    end

    def api
      @api ||= Api.new(client: self)
    end

    def decades
      DECADES
    end

    def moods
      MOODS
    end
  end
end
