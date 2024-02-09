# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Validations do
  describe "#validate_user_id!" do
    let(:user_id) { "5d3306de06fb03d8871fd138" }

    subject { described_class.validate_user_id!(user_id) }

    context "when input was identified as user ID" do
      it "returns true" do
        override_check(:mongo_id?, user_id, true)
        expect(subject).to eq true
      end
    end

    context "when input was not identified as user ID" do
      it "raises an error" do
        override_check(:mongo_id?, user_id, false)
        expect { subject }.to raise_error(ArgumentError, "invalid user ID: \"5d3306de06fb03d8871fd138\"")
      end
    end
  end

  describe "#validate_track_id!" do
    let(:track_id) { "5d3306de06fb03d8871fd138" }

    subject { described_class.validate_track_id!(track_id) }

    context "when input was identified as track ID" do
      it "returns nil" do
        override_check(:mongo_id?, track_id, true)
        expect(subject).to eq true
      end
    end

    context "when input was not identified as track ID" do
      it "raises an error" do
        override_check(:mongo_id?, track_id, false)
        expect { subject }.to raise_error(ArgumentError, "invalid track ID: \"5d3306de06fb03d8871fd138\"")
      end
    end
  end

  describe "#validate_island_id!" do
    let(:island_id) { "5d3306de06fb03d8871fd138" }

    subject { described_class.validate_island_id!(island_id) }

    context "when input was identified as island ID" do
      it "returns nil" do
        override_check(:mongo_id?, island_id, true)
        expect(subject).to eq true
      end
    end

    context "when input was not identified as island ID" do
      it "raises an error" do
        override_check(:mongo_id?, island_id, false)
        expect { subject }.to raise_error(ArgumentError, "invalid island ID: \"5d3306de06fb03d8871fd138\"")
      end
    end
  end

  describe "#validate_country_iso_codes!" do
    subject { described_class.validate_country_iso_codes!(iso_codes) }

    context "when input is not an array" do
      let(:iso_codes) { :xyz }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "country ISO codes should be an array: :xyz")
      end
    end

    context "when input is an array" do
      let(:iso_codes) { ["FRA", "ITA", "NOR"] }

      it "runs validation for each ISO code" do
        iso_codes.each do |iso_code|
          expect(described_class)
            .to receive(:validate_country_iso_code!)
            .with(iso_code)
            .exactly(1)
        end

        expect(subject).to eq true
      end
    end
  end

  describe "#validate_country_iso_code!" do
    let(:iso_code) { "FRA" }

    subject { described_class.validate_country_iso_code!(iso_code) }

    context "when input was identified as country ISO code" do
      it "returns true" do
        override_check(:country_iso_code?, iso_code, true)
        expect(subject).to eq true
      end
    end

    context "when input was not identified as country ISO code" do
      it "raises an error" do
        override_check(:country_iso_code?, iso_code, false)
        expect { subject }.to raise_error(ArgumentError, "invalid country ISO code: \"FRA\"")
      end
    end
  end

  describe "#validate_decades!" do
    subject { described_class.validate_decades!(decades) }

    context "when input is not an array" do
      let(:decades) { :xyz }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "decades should be an array: :xyz")
      end
    end

    context "when input is an array" do
      let(:decades) { [1960, 1970, 1980] }

      it "runs validation for each decade" do
        decades.each do |decade|
          expect(described_class)
            .to receive(:validate_decade!)
            .with(decade)
            .exactly(1)
        end

        expect(subject).to eq true
      end
    end
  end

  describe "#validate_decade!" do
    let(:decade) { 1970 }

    subject { described_class.validate_decade!(decade) }

    context "when input was identified as decade" do
      it "returns true" do
        override_check(:decade?, decade, true)
        expect(subject).to eq true
      end
    end

    context "when input was not identified as decade" do
      it "raises an error" do
        override_check(:decade?, decade, false)
        expect { subject }.to raise_error(ArgumentError, "invalid decade: 1970")
      end
    end
  end

  describe "#validate_moods!" do
    subject { described_class.validate_moods!(moods) }

    context "when input is not an array" do
      let(:moods) { :xyz }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "moods should be an array: :xyz")
      end
    end

    context "when input is an array" do
      let(:moods) { [:fast, :weird] }

      it "runs validation for each mood" do
        moods.each do |mood|
          expect(described_class)
            .to receive(:validate_mood!)
            .with(mood)
            .exactly(1)
        end

        expect(subject).to eq true
      end
    end
  end

  describe "#validate_mood!" do
    let(:mood) { :slow }

    subject { described_class.validate_mood!(mood) }

    context "when input was identified as mood" do
      it "returns true" do
        override_check(:mood?, mood, true)
        expect(subject).to eq true
      end
    end

    context "when input was not identified as mood" do
      it "raises an error" do
        override_check(:mood?, mood, false)
        expect { subject }.to raise_error(ArgumentError, "invalid mood: :slow")
      end
    end
  end

  describe "#validate_user_track_status!" do
    let(:status) { :on_air }

    subject { described_class.validate_user_track_status!(status) }

    context "when input was identified as user track status" do
      it "returns true" do
        override_check(:user_track_status?, status, true)
        expect(subject).to eq true
      end
    end

    context "when input was not identified as user track status" do
      it "raises an error" do
        override_check(:user_track_status?, status, false)
        expect { subject }.to raise_error(ArgumentError, "invalid user track status: :on_air")
      end
    end
  end

  describe "#validate_page_size!" do
    let(:size) { 10 }

    subject { described_class.validate_page_size!(size) }

    context "when input was identified as page size" do
      it "returns true" do
        override_check(:positive_number?, size, true)
        expect(subject).to eq true
      end
    end

    context "when input was not identified as page size" do
      it "raises an error" do
        override_check(:positive_number?, size, false)
        expect { subject }.to raise_error(ArgumentError, "invalid page size: 10")
      end
    end
  end

  describe "#validate_page_number!" do
    let(:page) { 5 }

    subject { described_class.validate_page_number!(page) }

    context "when input was identified as page number" do
      it "returns true" do
        override_check(:positive_number?, page, true)
        expect(subject).to eq true
      end
    end

    context "when input was not identified as page number" do
      it "raises an error" do
        override_check(:positive_number?, page, false)
        expect { subject }.to raise_error(ArgumentError, "invalid page number: 5")
      end
    end
  end

  def override_check(method, *args, result)
    allow(described_class)
      .to receive(method)
      .with(*args)
      .exactly(1)
      .and_return(result)
  end
end
