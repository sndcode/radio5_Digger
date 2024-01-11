# frozen_string_literal: true

require "json"
require "time"

module Radio5
  module Utils
    module_function

    ASSET_HOST = "https://asset.radiooooo.com"

    IMAGE_SIZES = {
      track: %i[thumb small medium large],
      user: %i[icon thumb small medium large]
    }.freeze

    def parse_json(json_raw)
      JSON.parse(json_raw, symbolize_names: true)
    end

    def parse_image_urls(node, entity:)
      if node
        path, filename = node.fetch_values(:path, :filename)
        image_sizes = IMAGE_SIZES.fetch(entity)

        image_sizes.each_with_object({}) do |image_size, hash|
          image_size_path = "#{path}#{image_size}/"
          image_url = create_asset_url(image_size_path, filename)

          hash[image_size] = image_url
        end
      end
    end

    def parse_asset_url(node)
      if node
        path, filename = node.fetch_values(:path, :filename)
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

    def stringify_user_track_status(status)
      USER_TRACK_STATUSES_MAPPING.fetch(status)
    end

    def symbolize_user_track_status(status)
      USER_TRACK_STATUSES_MAPPING.key(status)
    end
  end
end
