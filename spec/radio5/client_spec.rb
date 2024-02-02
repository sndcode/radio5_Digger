# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Client do
  let(:client) { described_class.new }

  describe "#new" do
    it "assigns default params" do
      expect(client).to have_attributes(
        open_timeout: 10,
        read_timeout: 10,
        write_timeout: 10,
        proxy_url: nil,
        max_retries: 3,
        debug_output: nil
      )
    end
  end

  describe "#decades" do
    subject { client.decades }

    it "returns decades constant" do
      expect(subject).to eq Radio5::DECADES
    end
  end

  describe "#moods" do
    subject { client.moods }

    it "returns moods constant" do
      expect(subject).to eq Radio5::MOODS
    end
  end
end
