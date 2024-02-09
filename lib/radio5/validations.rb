# frozen_string_literal: true

module Radio5
  module Validations
    module_function

    include Matchers
    extend Matchers

    def validate!
      yield

      true
    end

    def validate_user_id!(object)
      validate! do
        unless mongo_id?(object)
          raise ArgumentError, "invalid user ID: #{object.inspect}"
        end
      end
    end

    def validate_track_id!(object)
      validate! do
        unless mongo_id?(object)
          raise ArgumentError, "invalid track ID: #{object.inspect}"
        end
      end
    end

    def validate_island_id!(object)
      validate! do
        unless mongo_id?(object)
          raise ArgumentError, "invalid island ID: #{object.inspect}"
        end
      end
    end

    def validate_country_iso_codes!(iso_codes)
      validate! do
        unless iso_codes.is_a?(Array)
          raise ArgumentError, "country ISO codes should be an array: #{iso_codes.inspect}"
        end

        iso_codes.each do |iso_code|
          validate_country_iso_code!(iso_code)
        end
      end
    end

    def validate_country_iso_code!(object)
      validate! do
        unless country_iso_code?(object)
          raise ArgumentError, "invalid country ISO code: #{object.inspect}"
        end
      end
    end

    def validate_decades!(decades)
      validate! do
        unless decades.is_a?(Array)
          raise ArgumentError, "decades should be an array: #{decades.inspect}"
        end

        decades.each do |decade|
          validate_decade!(decade)
        end
      end
    end

    def validate_decade!(object)
      validate! do
        unless decade?(object)
          raise ArgumentError, "invalid decade: #{object.inspect}"
        end
      end
    end

    def validate_moods!(moods)
      validate! do
        unless moods.is_a?(Array)
          raise ArgumentError, "moods should be an array: #{moods.inspect}"
        end

        moods.each do |mood|
          validate_mood!(mood)
        end
      end
    end

    def validate_mood!(object)
      validate! do
        unless mood?(object)
          raise ArgumentError, "invalid mood: #{object.inspect}"
        end
      end
    end

    def validate_user_track_status!(object)
      validate! do
        unless user_track_status?(object)
          raise ArgumentError, "invalid user track status: #{object.inspect}"
        end
      end
    end

    def validate_page_size!(object)
      validate! do
        unless positive_number?(object)
          raise ArgumentError, "invalid page size: #{object.inspect}"
        end
      end
    end

    def validate_page_number!(object)
      validate! do
        unless positive_number?(object)
          raise ArgumentError, "invalid page number: #{object.inspect}"
        end
      end
    end
  end
end
