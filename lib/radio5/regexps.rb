# frozen_string_literal: true

module Radio5
  module Regexps
    include Utils

    # rubocop:disable Layout/ExtraSpacing

    MONGO_ID     = /^[a-f\d]{24}$/.freeze
    UUID_GENERIC = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/.freeze
    UUID         = /^#{UUID_GENERIC}$/.freeze

    COUNTRY_ISO_CODE_GENERIC = /([A-Z]{3}|KN1)/.freeze
    COUNTRY_ISO_CODE         = /^#{COUNTRY_ISO_CODE_GENERIC}$/.freeze

    ASSET_URL = lambda do |sub_path, exts, size = nil|
      asset_host = Regexp.escape(Utils::ASSET_HOST)
      sub_path   = sub_path.is_a?(Regexp) ? sub_path : Regexp.escape(sub_path)
      exts       = /(#{exts.join("|")})/
      size       = /\/#{size}/ if size

      /#{asset_host}#{sub_path}#{size}\/#{UUID_GENERIC}(_\d+)?\.#{exts}/
    end.freeze

    ISLAND_ICON_URL   = ASSET_URL.call("/island/icon", ["png", "svg"]).freeze
    ISLAND_SPLASH_URL = ASSET_URL.call("/island/splash", ["png", "svg"]).freeze
    ISLAND_MARKER_URL = ASSET_URL.call("/island/marker", ["png", "svg"]).freeze

    TRACK_COVER_URL = IMAGE_SIZES[:track].each_with_object({}) do |image_size, hash|
      url = ASSET_URL.call(/\/cover\/#{COUNTRY_ISO_CODE_GENERIC}\/\d{4}/, ["jpg", "jpeg", "png", "gif"], image_size.to_s)
      hash[image_size] = url
    end.freeze

    USER_IMAGE_URL = IMAGE_SIZES[:user].each_with_object({}) do |image_size, hash|
      url = ASSET_URL.call(/\/user\/\d+/, ["jpg", "jpeg", "png", "gif"], image_size.to_s)
      hash[image_size] = url
    end.freeze

    AUDIO_URL = lambda do |exts|
      exts = /(#{exts.join("|")})/

      /.+\/#{UUID_GENERIC}\.#{exts}\?token=[^&]{22}&expires=\d{10}$/
    end.freeze

    MPEG_URL = AUDIO_URL.call(["mp3", "m4a"]).freeze
    OGG_URL  = AUDIO_URL.call(["ogg"]).freeze

    # rubocop:enable Layout/ExtraSpacing
  end
end
