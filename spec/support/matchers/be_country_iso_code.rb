# frozen_string_literal: true

RSpec::Matchers.define :be_country_iso_code do
  match do |actual|
    actual.is_a?(String) && actual.size == 3
  end
end
