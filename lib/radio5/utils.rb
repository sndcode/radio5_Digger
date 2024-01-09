# frozen_string_literal: true

require "json"
require "time"

module Radio5
  module Utils
    module_function

    ASSET_HOST = "https://asset.radiooooo.com".freeze

    def parse_json(json_raw)
      JSON.parse(json_raw, symbolize_names: true)
    end

    def parse_asset_url(hash, key, size: nil)
      node = hash[key]

      if node
        path, filename = node.fetch_values(:path, :filename)
        path << "#{size}/" if size

        create_asset_url(path, filename)
      end
    end

    def create_asset_url(path, filename)
      URI.join(ASSET_HOST, path, filename).to_s
    end

    def parse_time_string(time_string)
      Time.parse(time_string).utc
    end

    def parse_unix_timestamp(ts)
      Time.at(ts).utc
    end

    def normalize_string(string)
      return if string.nil? || string.empty?

      normalized = string.strip
      normalized unless normalized.empty?
    end

    def stringify_moods(moods)
      moods.map { |mood| MOODS_MAPPING.fetch(mood) }
    end

    def symbolize_mood(mood)
      MOODS_MAPPING.key(mood)
    end
  end
end
