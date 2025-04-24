# frozen_string_literal: true

module Radio5
  module Validations
    module Matchers
      module_function

      def mongo_id?(object)
        object.is_a?(String) && object.match?(Regexps::MONGO_ID)
      end

      def country_iso_code?(object)
        object.is_a?(String) && object.match?(Regexps::COUNTRY_ISO_CODE)
      end

      def decade?(object)
        object.is_a?(Integer) && Constants::DECADES.include?(object)
      end

      def mood?(object)
        object.is_a?(Symbol) && Constants::MOODS.include?(object)
      end

      def user_track_status?(object)
        object.is_a?(Symbol) && Constants::USER_TRACK_STATUSES.include?(object)
      end

      def positive_number?(object)
        object.is_a?(Integer) && object.positive?
      end
    end
  end
end
