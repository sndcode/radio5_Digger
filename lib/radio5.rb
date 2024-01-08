# frozen_string_literal: true

require_relative "radio5/version"
require_relative "radio5/utils"
require_relative "radio5/http"
require_relative "radio5/api"
require_relative "radio5/regexps"
require_relative "radio5/validator"
require_relative "radio5/client/users"
require_relative "radio5/client/countries"
require_relative "radio5/client/islands"
require_relative "radio5/client/tracks"
require_relative "radio5/client"

module Radio5
  DECADES = (1900..2020).step(10).to_a.freeze

  MOODS_MAPPING = {
    fast: "FAST",
    slow: "SLOW",
    weird: "WEIRD"
  }.freeze

  MOODS = MOODS_MAPPING.keys.freeze
end
