# frozen_string_literal: true

module Radio5
  class Client
    module Users
      def user(id)
        validate_user_id!(id)

        _, json = api.get("/contributor/#{id}")

        Parser.user_info(json)
      rescue Api::UserNotFound
        nil
      end

      def user_tracks(id, status: :on_air, size: MAX_PAGE_SIZE, page: 1)
        validate_user_id!(id)
        validate_user_track_status!(status)
        validate_page_size!(size)
        validate_page_number!(page)

        query_params = {
          status: stringify_user_track_status(status),
          size: size,
          page: page
        }

        _, json = api.get("/contributor/uploaded/#{id}", query_params: query_params)

        json.map do |track|
          Parser.user_track_info(track)
        end
      end

      def user_follow_counts(id)
        validate_user_id!(id)

        _, json = api.get("/follow/count/#{id}")

        {
          followings: json.fetch(:following),
          followers: json.fetch(:followers)
        }
      end

      def user_followers(id, size: MAX_PAGE_SIZE, page: 1)
        validate_user_id!(id)
        validate_page_size!(size)
        validate_page_number!(page)

        _, json = api.get("/follow/list/follower/#{id}", query_params: {size: size, page: page})

        json.map do |user|
          Parser.follow_user_info(user)
        end
      end

      def user_followings(id, size: MAX_PAGE_SIZE, page: 1)
        validate_user_id!(id)
        validate_page_size!(size)
        validate_page_number!(page)

        _, json = api.get("/follow/list/following/#{id}", query_params: {size: size, page: page})

        json.map do |user|
          Parser.follow_user_info(user)
        end
      end

      def user_liked_tracks
        raise NotImplementedError, "depends on auth"
      end

      # rubocop:disable Layout/HashAlignment
      module Parser
        extend Utils

        def self.user_info(json)
          birthday = if json[:birthday]
            time = parse_time_string(json[:birthday])
            year_normalized = normalize_year(time)

            {
              time: time,
              year_normalized: year_normalized
            }
          end

          {
            id:         json.fetch(:_id),
            uuid:       json.fetch(:uuid),
            name:       normalize_string(json.fetch(:pseudonym)),
            info:       normalize_string(json[:info]),
            country:    json[:country],
            rank:       json.fetch(:ranking),
            image_url:  parse_image_urls(json[:image], entity: :user),
            birthday:   birthday,
            created_at: parse_time_string(json.fetch(:created))
          }
        end

        def self.user_track_info(track)
          cover_node = track[:image] || track[:cover]
          cover_url = parse_image_urls(cover_node, entity: :track)

          {
            id:          track.fetch(:_id),
            uuid:        track.fetch(:uuid),
            artist:      normalize_string(track.fetch(:artist)),
            title:       normalize_string(track.fetch(:title)),
            year:        normalize_string(track.fetch(:year)),
            cover_url:   cover_url,
            decade:      track.fetch(:decade),
            country:     track.fetch(:country),
            like_count:  track.fetch(:likes),
            status:      symbolize_user_track_status(track[:status])
          }
        end

        # TODO: strange name tbh, change later
        def self.follow_user_info(user)
          {
            id:         user.fetch(:_id),
            name:       normalize_string(user.fetch(:pseudonym)),
            country:    user[:country],
            rank:       user.fetch(:ranking),
            image_url:  parse_image_urls(user[:image], entity: :user),
            created_at: parse_time_string(user.fetch(:created))
          }
        end

        def self.normalize_year(time)
          if time.month == 12
            time.year + 1
          else
            time.year
          end
        end
      end
      # rubocop:enable Layout/HashAlignment
    end
  end
end
