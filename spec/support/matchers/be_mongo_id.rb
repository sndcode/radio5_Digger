# frozen_string_literal: true

RSpec::Matchers.define :be_mongo_id do
  match do |actual|
    Radio5::Validator.mongo_id?(actual)
  end
end
