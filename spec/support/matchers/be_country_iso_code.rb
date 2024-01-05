# frozen_string_literal: true

RSpec::Matchers.define :be_country_iso_code do
  match do |actual|
    Radio5::Validator.country_iso_code?(actual)
  end
end
