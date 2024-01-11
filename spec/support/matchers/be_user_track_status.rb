# frozen_string_literal: true

RSpec::Matchers.define :be_user_track_status do
  match do |actual|
    Radio5::Validator.user_track_status?(actual)
  end
end
