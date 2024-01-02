# frozen_string_literal: true

module Radio5
  class Client
    module Countries
      def countries
        response = api.get("/language/countries/en.json")
        json = JSON.parse(response.body)

        json.each_with_object({}) do |(iso_code, name, exist, rank), countries|
          countries[iso_code] = {
            name: name,
            exist: exist,
            rank: rank
          }
        end
      end

      def countries_per_decade(decade)
        unless decade.is_a?(Integer)
          raise ArgumentError, "decade `#{decade}` should be an Integer"
        end

        unless DECADES.include?(decade)
          raise ArgumentError, "decade `#{decade}` should be in the range from #{DECADES.first} to #{DECADES.last}"
        end

        response = api.get("/country/mood", query_params: {decade: decade})
        json = JSON.parse(response.body)

        json.transform_keys do |mood_string|
          MOODS_MAPPING.fetch(mood_string) do
            raise ArgumentError, "unknown mood `#{mood_string}`"
          end
        end
      end
    end
  end
end
