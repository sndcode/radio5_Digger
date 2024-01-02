# frozen_string_literal: true

require "json"

module Radio5
  class Client
    include Users
    include Countries
    include Islands
    include Utils

    attr_reader :session_id, :api

    # def initialize(
    #   session_id: nil,
    #   username: nil,
    #   password: nil,
    #   open_timeout: nil,
    #   read_timeout: nil,
    #   write_timeout: nil,
    #   proxy_url: nil,
    #   debug_output: nil
    # )

    def initialize(session_id: nil, username: nil, password: nil, open_timeout: nil, read_timeout: nil, write_timeout: nil, proxy_url: nil, debug_output: nil)
      @session_id = session_id
      @username = username
      @password = password

      @api = Http.new(
        host: "radiooooo.com",
        port: 443,
        open_timeout: open_timeout,
        read_timeout: read_timeout,
        write_timeout: write_timeout,
        proxy_url: proxy_url,
        debug_output: debug_output
      )
    end

    # if session_id passed
    #   - check me
    #      if ok - nothing
    #      if fail - expired, check if username / password present, try to login

    def login(username: nil, password: nil)
      # raise if no credentials provided

      # session_id first
      # username/pass second

      new_session_id = "" # from response
      @session_id = new_session_id

      # should return user info
    end

    def session_header
      if session_id.nil? || session_id.empty?
        # ...
      end

      {
        sid: session_id
      }
    end

    def me
      # info about user itself
      # auth required
    end

    def authed?
      # if account_info request returns actual info JSON
    end
  end
end
