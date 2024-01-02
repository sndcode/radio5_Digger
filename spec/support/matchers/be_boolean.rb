# frozen_string_literal: true

RSpec::Matchers.define :be_boolean do
  match do |actual|
    actual.is_a?(TrueClass) || actual.is_a?(FalseClass)
  end
end
