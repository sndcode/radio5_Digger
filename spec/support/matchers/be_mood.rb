# frozen_string_literal: true

RSpec::Matchers.define :be_mood do
  match do |actual|
    Radio5::Validator.mood?(actual)
  end
end
