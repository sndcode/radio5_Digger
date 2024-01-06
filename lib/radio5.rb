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
  DECADES = (1900..2020).step(10).to_a

  MOODS_TO_STR = {fast: "FAST", slow: "SLOW", weird: "WEIRD"}
  MOODS_TO_SYM = MOODS_TO_STR.invert
  MOODS = MOODS_TO_STR.keys
end
