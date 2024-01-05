# frozen_string_literal: true

RSpec::Matchers.define :be_decade do
  match do |actual|
    Radio5::Validator.decade?(actual)
  end
end
