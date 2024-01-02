# frozen_string_literal: true

require "spec_helper"
require "webmock/rspec"

RSpec.describe Radio5::Client::Countries do
  let(:client) { Radio5::Client.new }

  describe "#countries" do
    subject { client.countries }

    it "returns countries hash" do
      vcr("client/countries/en") do
        expect(subject.size).to be > 200

        subject.each do |iso_code, country|
          expect(iso_code).to be_filled_string
          expect(country).to match(
            name: be_filled_string,
            exist: be_boolean,
            rank: be_between(1, 10).or(be_nil)
          )
        end
      end
    end
  end

  describe "#countries_per_decade" do
    subject { client.countries_per_decade(decade) }

    context "with invalid decade value" do
      let(:decade) { "xyz" }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "decade `xyz` should be an Integer")
      end
    end

    context "with out of scope decade" do
      let(:decade) { 1890 }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "decade `1890` should be in the range from 1900 to 2020")
      end
    end

    context "with supported decade" do
      let(:decade) { 1970 }

      it "returns mood-to-countries hash" do
        vcr("client/countries_per_decade/#{decade}") do
          expect(subject.keys.sort).to eq Radio5::MOODS

          subject.each do |mood, countries|
            expect(countries).to_not be_empty
            expect(countries).to all be_filled_string
          end
        end
      end
    end

    context "with unknown mood returned" do
      before do
        WebMock.disable_net_connect!(allow: /\/country\/mood/)
      end

      after do
        WebMock.disable_net_connect!
      end

      let(:decade) { 1970 }

      it "raises an error" do
        stub_request(:get, /\/country\/mood/)
          .to_return(body: {"SLOW" => ["GBR", "FRA"], "XYZ" => ["GBR", "FRA"]}.to_json)

        expect { subject }.to raise_error(ArgumentError, "unknown mood `XYZ`")
      end
    end
  end
end
