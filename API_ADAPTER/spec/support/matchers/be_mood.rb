# frozen_string_literal: true

RSpec::Matchers.define :be_mood do
  match do |actual|
    Radio5::Validations::Matchers.mood?(actual)
  end
end
