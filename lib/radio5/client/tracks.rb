# frozen_string_literal: true

module Radio5
  class Client
    module Tracks
      include Constants

      def track(track_id)
        validate_track_id!(track_id)

        _, json = api.get("/track/play/#{track_id}")

        Parser.track_info(json)
      rescue Api::TrackNotFound
        nil
      end

      # TODO: technically, API accepts an array of countries, but without premium
      # account only the first one is used during filtering.
      #   `country` should be used for now
      #   `countries` might be added in a future after implementation of auth
      def random_track(country: nil, decades: [], moods: MOODS)
        iso_codes = country ? [country] : []

        validate_country_iso_codes!(iso_codes)
        validate_decades!(decades)
        validate_moods!(moods)

        body = {
          mode:     "explore",
          isocodes: iso_codes,
          decades:  decades.uniq,
          moods:    stringify_moods(moods).uniq
        }.to_json

        _, json = api.post("/play", body: body)

        Parser.track_info(json)
      rescue Api::MatchingTrackNotFound
        nil
      end

      def island_track(island_id:, moods: MOODS)
        validate_island_id!(island_id)
        validate_moods!(moods)

        body = {
          mode:   "islands",
          island: island_id,
          moods:  stringify_moods(moods).uniq
        }.to_json

        _, json = api.post("/play", body: body)

        Parser.track_info(json)
      rescue Api::MatchingTrackNotFound
        nil
      end

      module Parser
        extend Utils

        def self.track_info(json)
          created_node = json[:created]
          created_at = created_node && parse_time_string(created_node.fetch(:date))
          created_by = created_node ? created_node.fetch(:user_id) : json.fetch(:profile_id)

          cover_node = json[:image] || json[:cover]
          cover_url = parse_image_urls(cover_node, entity: :track)

          audio = {
            mpeg: track_audio(json, :mpeg),
            ogg:  track_audio(json, :ogg)
          }

          {
            id:          json.fetch(:_id),
            uuid:        json.fetch(:uuid),
            artist:      normalize_string(json.fetch(:artist)),
            title:       normalize_string(json.fetch(:title)),
            album:       normalize_string(json[:album]),
            year:        normalize_string(json.fetch(:year)),
            label:       normalize_string(json[:label]),
            songwriter:  normalize_string(json[:songwriter]),
            length:      json.fetch(:length),
            info:        normalize_string(json[:info]),
            cover_url:   cover_url,
            audio:       audio,
            decade:      json.fetch(:decade),
            mood:        symbolize_mood(json.fetch(:mood)),
            country:     json.fetch(:country),
            like_count:  json.fetch(:likes),
            created_at:  created_at,
            created_by:  created_by
          }
        end

        def self.track_audio(json, format)
          url = json.fetch(:links).fetch(format)
          url.gsub!(/#t=\d*,\d+/, "") # remove play time limit

          expires_at_unix = Integer(url[/(?<=expires=)\d+/])
          expires_at = parse_unix_timestamp(expires_at_unix)

          {
            url: url,
            expires_at: expires_at
          }
        end
      end
    end
  end
end
