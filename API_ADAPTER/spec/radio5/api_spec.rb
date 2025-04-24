# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Api do
  let(:client) { Radio5::Client.new }

  subject(:random_track) { client.random_track }

  before :all do
    WebMock.disable_net_connect!(allow: /\/play$/)
  end

  after :all do
    WebMock.disable_net_connect!
  end

  context "with unknown API error" do
    it "raises an error" do
      stub_request(:post, /\/play$/)
        .to_return(body: {"error" => "Other API error"}.to_json)

      expect { random_track }.to raise_error(Radio5::Api::Error, "Other API error")
    end
  end

  context "with unexpected response" do
    it "raises an error" do
      stub_request(:post, /\/play$/)
        .to_return(
          status: 418,
          body: "tea is better than coffee"
        )

      expect { random_track }.to raise_error(
        Radio5::Api::UnexpectedResponse,
        "code: \"418\", body: \"tea is better than coffee\""
      )
    end
  end
end
