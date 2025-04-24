# frozen_string_literal: true

RSpec::Matchers.define :be_mpeg_url do
  match do |actual|
    actual.is_a?(String) && actual.match?(Radio5::Validations::Regexps::MPEG_URL)
  end
end
