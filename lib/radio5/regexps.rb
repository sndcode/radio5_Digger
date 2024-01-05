# frozen_string_literal: true

module Radio5
  module Regexps
    # rubocop:disable Layout/ExtraSpacing

    MONGO_ID     = /^[a-f\d]{24}$/
    UUID_GENERIC = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    UUID         = /^#{UUID_GENERIC}$/

    COUNTRY_ISO_CODE_GENERIC = /([A-Z]{3}|KN1)/
    COUNTRY_ISO_CODE         = /^#{COUNTRY_ISO_CODE_GENERIC}$/

    ASSET_URL = lambda do |sub_path, exts|
      asset_host = Regexp.escape(Utils::ASSET_HOST)
      sub_path   = sub_path.is_a?(Regexp) ? sub_path : Regexp.escape(sub_path)
      exts       = /(#{exts.join("|")})/

      /#{asset_host}#{sub_path}\/#{UUID_GENERIC}(_\d+)?\.#{exts}/
    end

    ISLAND_ICON_URL   = ASSET_URL.call("/island/icon", ["png", "svg"])
    ISLAND_SPLASH_URL = ASSET_URL.call("/island/splash", ["png", "svg"])
    ISLAND_MARKER_URL = ASSET_URL.call("/island/marker", ["png", "svg"])
    TRACK_COVER_URL   = ASSET_URL.call(/\/cover\/#{COUNTRY_ISO_CODE_GENERIC}\/\d{4}/, ["jpg", "jpeg"])

    AUDIO_URL = lambda do |exts|
      exts = /(#{exts.join("|")})/

      /.+\/#{UUID_GENERIC}\.#{exts}\?token=[^&]{22}&expires=\d{10}$/
    end

    MPEG_URL = AUDIO_URL.call(["mp3", "m4a"])
    OGG_URL  = AUDIO_URL.call(["ogg"])

    # rubocop:enable Layout/ExtraSpacing
  end
end
