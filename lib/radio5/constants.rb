# frozen_string_literal: true

module Radio5
  module Constants
    # rubocop:disable Layout/HashAlignment

    DECADES = (1900..2020).step(10).to_a.freeze

    MOODS_MAPPING = {
      fast:  "FAST",
      slow:  "SLOW",
      weird: "WEIRD"
    }.freeze

    MOODS = MOODS_MAPPING.keys.freeze

    USER_TRACK_STATUSES_MAPPING = {
      posted:       "posted",
      rejected:     "rejected",
      on_air:       "onair",
      confirmation: "confirmation",
      duplicate:    "duplicate",
      deleted:      "deleted",
      broken:       "broken"
    }.freeze

    USER_TRACK_STATUSES = USER_TRACK_STATUSES_MAPPING.keys.freeze

    IMAGE_SIZES = {
      track: %i[thumb small medium large],
      user:  %i[icon thumb small medium large]
    }.freeze

    ASSET_HOST = "https://asset.radiooooo.com"

    MAX_PAGE_SIZE = 1_000_000_000

    # rubocop:enable Layout/HashAlignment
  end
end
