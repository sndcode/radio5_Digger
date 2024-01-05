# frozen_string_literal: true

module Radio5
  class Client
    module Countries
      def countries
        response = api.get("/language/countries/en.json")
        json = parse_json(response.body)

        json.each_with_object({}) do |(iso_code, name, exist, rank), countries|
          countries[iso_code] = {
            name: name,
            exist: exist,
            rank: rank
          }
        end
      end

      def countries_for_decade(decade, group_by: :mood)
        validate_decade!(decade)

        # optimization to avoid doing this inside `case` to save HTTP request
        unless [:mood, :country].include?(group_by)
          raise ArgumentError, "invalid `group_by` value: #{group_by.inspect}"
        end

        response = api.get("/country/mood", query_params: {decade: decade})
        json = parse_json(response.body)

        grouped_by_mood = json.transform_keys do |mood_upcased|
          mood = mood_upcased.downcase

          validate_mood!(mood)

          mood
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
