# frozen_string_literal: true

module Radio5
  module Validations
    module Regexps
      include Constants

      MONGO_ID     = /\A[a-f\d]{24}\z/.freeze
      UUID_GENERIC = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/.freeze
      UUID         = /\A#{UUID_GENERIC}\z/.freeze

      COUNTRY_ISO_CODE_GENERIC = /([A-Z]{3}|KN1)/.freeze
      COUNTRY_ISO_CODE         = /\A#{COUNTRY_ISO_CODE_GENERIC}\z/.freeze

      # NOTE: everything below is used within RSpec custom matchers, they might be
      # migrated to regular validations matchers in future, in case there will be
      # a need to validate fields in response payloads on the fly

      ASSET_URL = lambda do |sub_path, exts, size = nil|
        asset_host = Regexp.escape(ASSET_HOST)
        sub_path   = sub_path.is_a?(Regexp) ? sub_path : Regexp.escape(sub_path)
        exts       = /(#{exts.join("|")})/
        size       = /\/#{size}/ if size

        /#{asset_host}#{sub_path}#{size}\/#{UUID_GENERIC}(_\d+)?\.#{exts}/.freeze
      end.freeze

      ISLAND_ICON_URL   = ASSET_URL.call("/island/icon", %w[png svg])
      ISLAND_SPLASH_URL = ASSET_URL.call("/island/splash", %w[png svg])
      ISLAND_MARKER_URL = ASSET_URL.call("/island/marker", %w[png svg])

      TRACK_COVER_URLS = IMAGE_SIZES[:track].each_with_object({}) do |image_size, hash|
        sub_path = %r(/cover/#{COUNTRY_ISO_CODE_GENERIC}/\d{4})
        exts     = %w[jpg jpeg png gif]
        regexp   = ASSET_URL.call(sub_path, exts, image_size)

        hash[image_size] = regexp
      end.freeze

      USER_IMAGE_URLS = IMAGE_SIZES[:user].each_with_object({}) do |image_size, hash|
        sub_path = %r{/user/\d+}
        exts     = %w[jpg jpeg png gif]
        regexp   = ASSET_URL.call(sub_path, exts, image_size)

        hash[image_size] = regexp
      end.freeze

      AUDIO_URL = lambda do |exts|
        exts = /(#{exts.join("|")})/

        /.+\/#{UUID_GENERIC}\.#{exts}\?token=[^&]{22}&expires=\d{10}$/.freeze
      end.freeze

      MPEG_URL = AUDIO_URL.call(["mp3", "m4a"]).freeze
      OGG_URL  = AUDIO_URL.call(["ogg"]).freeze
    end
  end
end
