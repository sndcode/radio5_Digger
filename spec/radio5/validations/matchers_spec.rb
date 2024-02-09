# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Validations::Matchers do
  describe "#mongo_id?" do
    it "returns correct result" do
      examples = {
        "5d3306de06fb03d8871fd138" => true,
        "123" => false,
        :xyz => false
      }

      examples.each do |input, expected_result|
        result = described_class.mongo_id?(input)
        expect(result).to eq expected_result
      end
    end
  end

  describe "#country_iso_code?" do
    it "returns correct result" do
      examples = {
        "FRA" => true,
        "KN1" => true,
        "KN2" => false,
        "123" => false,
        :xyz => false
      }

      examples.each do |input, expected_result|
        result = described_class.country_iso_code?(input)
        expect(result).to eq expected_result
      end
    end
  end

  describe "#decade?" do
    it "returns correct result" do
      examples = {
        1970 => true,
        1971 => false,
        1890 => false,
        2030 => false,
        "1970" => false
      }

      examples.each do |input, expected_result|
        result = described_class.decade?(input)
        expect(result).to eq expected_result
      end
    end
  end

  describe "#mood?" do
    it "returns correct result" do
      examples = {
        :fast => true,
        "fast" => false,
        :xyz => false
      }

      examples.each do |input, expected_result|
        result = described_class.mood?(input)
        expect(result).to eq expected_result
      end
    end
  end

  describe "#user_track_status?" do
    it "returns correct result" do
      examples = {
        :on_air => true,
        "on_air" => false,
        :smth => false
      }

      examples.each do |input, expected_result|
        result = described_class.user_track_status?(input)
        expect(result).to eq expected_result
      end
    end
  end

  describe "#positive_number?" do
    it "returns correct result" do
      examples = {
        1 => true,
        0 => false,
        "1" => false
      }

      examples.each do |input, expected_result|
        result = described_class.positive_number?(input)
        expect(result).to eq expected_result
      end
    end
  end
end
