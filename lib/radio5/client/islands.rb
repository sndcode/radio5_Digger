# frozen_string_literal: true

module Radio5
  class Client
    module Islands
      def islands
        _, json = api.get("/island/all")

        json.map do |island|
          Parser.island_info(island)
        end
      end

      module Parser
        extend Utils

        def self.island_info(island)
          rank_value = island[:sort]
          rank = rank_value if rank_value.is_a?(Integer)

          created_at = parse_time_string(island.fetch(:created).fetch(:date))
          created_by = island.fetch(:created).fetch(:user_id)

          updated_node = island[:modified]
          updated_at = updated_node && parse_time_string(updated_node.fetch(:date))
          updated_by = updated_node&.fetch(:user_id)

          {
            id:              island.fetch(:_id),
            uuid:            island.fetch(:uuid),
            api_id:          island[:apiid],
            name:            normalize_string(island.fetch(:name)),
            info:            normalize_string(island[:info]),
            category:        normalize_string(island[:category]),
            favourite_count: island[:favorites],
            play_count:      island.fetch(:plays),
            rank:            rank,
            icon_url:        parse_asset_url(island[:icon]),
            splash_url:      parse_asset_url(island[:splash]),
            marker_url:      parse_asset_url(island[:marker]),
            enabled:         island.fetch(:enabled),
            free:            island[:free],
            on_map:          island.fetch(:onmap),
            random:          island.fetch(:random),
            play_mode:       island[:play],
            created_at:      created_at,
            created_by:      created_by,
            updated_at:      updated_at,
            updated_by:      updated_by
          }
        end
      end
    end
  end
end
