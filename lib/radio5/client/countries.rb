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

      def countries_for_decade(decade, group_by: :mood)
        unless decade.is_a?(Integer)
          raise ArgumentError, "decade `#{decade.inspect}` should be an Integer"
        end

        unless DECADES.include?(decade)
          raise ArgumentError, "decade `#{decade.inspect}` should be in the range from #{DECADES.first} to #{DECADES.last}"
        end

        # optimization to avoid doing this inside `case` to save HTTP request
        unless [:mood, :country].include?(group_by)
          raise ArgumentError, "unsupported `group_by` value: `#{group_by.inspect}`"
        end

        response = api.get("/country/mood", query_params: {decade: decade})
        json = JSON.parse(response.body)

        grouped_by_mood = json.transform_keys do |mood_string|
          MOODS_MAPPING.fetch(mood_string) do
            raise ArgumentError, "unknown mood `#{mood_string}`"
          end
        end

        case group_by
        when :mood
          grouped_by_mood
        when :country
          grouped_by_country = Hash.new { |hash, country| hash[country] = [] }

          MOODS.each_with_object(grouped_by_country) do |mood, grouped_by_country|
            grouped_by_mood[mood].each do |country|
              grouped_by_country[country] << mood
            end
          end
        end
      end
    end
  end
end
