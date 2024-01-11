# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Client do
  let(:client) { described_class.new }

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
