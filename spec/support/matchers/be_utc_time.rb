# frozen_string_literal: true

RSpec::Matchers.define :be_utc_time do
  match do |actual|
    actual.is_a?(Time) && actual.utc?
  end
end
