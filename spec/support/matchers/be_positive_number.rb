# frozen_string_literal: true

RSpec::Matchers.define :be_positive_number do
  match do |actual|
    Radio5::Validator.positive_number?(actual)
  end
end
