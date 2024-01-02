# frozen_string_literal: true

module Radio5
  class Client
    module Islands
      # rubocop:disable Layout/HashAlignment
      def islands
        response = api.get("/island/all")
        json = JSON.parse(response.body)

        json.map do |island|
          rank_value = island["sort"]
          rank = rank_value if rank_value.is_a?(Integer)

          created_at = Time.parse(island.fetch("created").fetch("date"))
          created_by = island.fetch("created").fetch("user_id")

          modified_node = island["modified"]
          modified_at = Time.parse(modified_node.fetch("date")) if modified_node
          modified_by = modified_node.fetch("user_id") if modified_node

          {
            id:              island.fetch("_id"),
            uuid:            island.fetch("uuid"),
            api_id:          island.fetch("apiid") { nil },
            name:            island.fetch("name"),
            info:            island.fetch("info") { nil },
            category:        island.fetch("category") { nil },
            favourite_count: island.fetch("favorites") { nil },
            play_count:      island.fetch("plays"),
            rank:            rank,
            icon_url:        parse_asset_url(island, "icon"),
            splash_url:      parse_asset_url(island, "splash"),
            marker_url:      parse_asset_url(island, "marker"),
            enabled:         island.fetch("enabled"),
            free:            island.fetch("free") { nil },
            on_map:          island.fetch("onmap"),
            random:          island.fetch("random"),
            play_mode:       island.fetch("play") { nil },
            created_at:      created_at,
            created_by:      created_by,
            modified_at:     modified_at,
            modified_by:     modified_by
          }
        end
        # rubocop:enable Layout/HashAlignment
      end
    end
  end
end
