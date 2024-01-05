# frozen_string_literal: true

RSpec::Matchers.define :be_track_cover_url do
  match do |actual|
    actual.is_a?(String) && actual.match?(Radio5::Regexps::TRACK_COVER_URL)
  end
end
