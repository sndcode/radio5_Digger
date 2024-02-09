# frozen_string_literal: true

RSpec::Matchers.define :be_user_image_url do |image_size|
  match do |actual|
    regexp = Radio5::Validations::Regexps::USER_IMAGE_URLS.fetch(image_size)

    actual.is_a?(String) && actual.match?(regexp)
  end
end
