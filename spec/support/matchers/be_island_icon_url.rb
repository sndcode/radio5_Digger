# frozen_string_literal: true

RSpec::Matchers.define :be_island_icon_url do
  match do |actual|
    actual.is_a?(String) && actual.match?(Radio5::Regexps::ISLAND_ICON_URL)
  end
end
