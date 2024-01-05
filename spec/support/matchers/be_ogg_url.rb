# frozen_string_literal: true

RSpec::Matchers.define :be_ogg_url do
  match do |actual|
    actual.is_a?(String) && actual.match?(Radio5::Regexps::OGG_URL)
  end
end
