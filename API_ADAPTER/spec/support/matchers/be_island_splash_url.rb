# frozen_string_literal: true

RSpec::Matchers.define :be_island_splash_url do
  match do |actual|
    actual.is_a?(String) && actual.match?(Radio5::Validations::Regexps::ISLAND_SPLASH_URL)
  end
end
