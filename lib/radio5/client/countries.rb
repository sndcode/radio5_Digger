# frozen_string_literal: true

module Radio5
  class Client
    module Countries
      include Constants

      def countries
        _, json = api.get("/language/countries/en.json")

        json.each_with_object({}) do |(iso_code, name, exist, rank), countries|
          countries[iso_code] = {
            name: name,
            exist: exist,
            rank: rank
          }
        end
      end

      def countries_for_decade(decade, group_by: :country)
        validate_decade!(decade)

        case group_by
        when :mood
          Fetcher.grouped_by_mood(api, decade)
        when :country
          grouped_by_mood = Fetcher.grouped_by_mood(api, decade)
          grouped_by_country = Hash.new { |hash, country| hash[country] = [] }

          MOODS.each_with_object(grouped_by_country) do |mood, grouped_by_country|
            grouped_by_mood[mood].each do |country|
              grouped_by_country[country] << mood
            end
          end
        else
          raise ArgumentError, "invalid `group_by` value: #{group_by.inspect}"
        end
      end

      module Fetcher
        def self.grouped_by_mood(api, decade)
          _, json = api.get("/country/mood", query_params: {decade: decade})

          json.transform_keys!(&:downcase)
        end
      end
    end
  end
end
