# frozen_string_literal: true

module Radio5
  module Validator
    module_function

    def mongo_id?(object)
      object.is_a?(String) && object.match?(Regexps::MONGO_ID)
    end

    def country_iso_code?(object)
      object.is_a?(String) && object.match?(Regexps::COUNTRY_ISO_CODE)
    end

    def decade?(object)
      object.is_a?(Integer) && DECADES.include?(object)
    end

    def mood?(object)
      object.is_a?(Symbol) && MOODS.include?(object)
    end

    def validate_track_id!(object)
      unless mongo_id?(object)
        raise ArgumentError, "invalid track ID: #{object.inspect}"
      end
    end

    def validate_island_id!(object)
      unless mongo_id?(object)
        raise ArgumentError, "invalid island ID: #{object.inspect}"
      end
    end

    def validate_country_iso_codes!(iso_codes)
      unless iso_codes.is_a?(Array)
        raise ArgumentError, "country ISO codes should be an array"
      end

      iso_codes.each do |iso_code|
        validate_country_iso_code!(iso_code)
      end
    end

    def validate_country_iso_code!(object)
      unless country_iso_code?(object)
        raise ArgumentError, "invalid country ISO code: #{object.inspect}"
      end
    end

    def validate_decades!(decades)
      unless decades.is_a?(Array)
        raise ArgumentError, "decades should be an array"
      end

      decades.each do |decade|
        validate_decade!(decade)
      end
    end

    def validate_decade!(object)
      unless decade?(object)
        raise ArgumentError, "invalid decade: #{object.inspect}"
      end
    end

    def validate_moods!(moods)
      unless moods.is_a?(Array)
        raise ArgumentError, "moods should be an array"
      end

      moods.each do |mood|
        validate_mood!(mood)
      end
    end

    def validate_mood!(object)
      unless mood?(object)
        raise ArgumentError, "invalid mood: #{object.inspect}"
      end
    end
  end
end
