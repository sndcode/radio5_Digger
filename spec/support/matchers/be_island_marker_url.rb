# frozen_string_literal: true

RSpec::Matchers.define :be_island_marker_url do
  match do |actual|
    actual.is_a?(String) && actual.match?(Radio5::Validations::Regexps::ISLAND_MARKER_URL)
  end
end
