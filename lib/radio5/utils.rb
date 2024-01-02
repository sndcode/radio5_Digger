# frozen_string_literal: true

module Radio5
  module Utils
    module_function

    ASSET_URL = "https://asset.radiooooo.com"

    def parse_asset_url(hash, key)
      node = hash[key]
      node && create_asset_url(*node.fetch_values("path", "filename"))
    end

    def create_asset_url(path, filename)
      URI.join(ASSET_URL, path, filename).to_s
    end
  end
end
