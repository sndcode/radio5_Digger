# frozen_string_literal: true

RSpec::Matchers.define :be_decade do
  match do |actual|
    Radio5::Validations::Matchers.decade?(actual)
  end
end
