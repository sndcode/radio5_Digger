# frozen_string_literal: true

RSpec::Matchers.define :be_uuid do
  match do |actual|
    actual.is_a?(String) && actual.match?(Radio5::Regexps::UUID)
  end
end
