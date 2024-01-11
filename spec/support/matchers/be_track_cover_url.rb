# frozen_string_literal: true

RSpec::Matchers.define :be_track_cover_url do |image_size|
  match do |actual|
    regexp = Radio5::Regexps::TRACK_COVER_URL.fetch(image_size)

    actual.is_a?(String) && actual.match?(regexp)
  end
end
