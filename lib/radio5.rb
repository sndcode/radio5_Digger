# frozen_string_literal: true

require_relative "radio5/version"
require_relative "radio5/http"
require_relative "radio5/utils"
require_relative "radio5/client/users"
require_relative "radio5/client/countries"
require_relative "radio5/client/islands"
require_relative "radio5/client"

module Radio5
  DECADES = (1900..2020).step(10).to_a

  MOODS_MAPPING = {
    "FAST" => :fast,
    "SLOW" => :slow,
    "WEIRD" => :weird
  }

  MOODS = MOODS_MAPPING.values
end
