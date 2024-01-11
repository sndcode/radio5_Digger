# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Client::Countries do
  include ValidatorHelpers

  let(:client) { Radio5::Client.new }

  describe "#countries" do
    subject { client.countries }

    it "returns countries hash" do
      vcr("client/countries/en") do
        expect(subject.size).to be > 200

        subject.each do |iso_code, country|
          expect(iso_code).to be_country_iso_code
          expect(country).to match(
            name: be_filled_string,
            exist: be_boolean,
            rank: be_between(1, 10).or(be_nil)
          )
        end
      end
    end
  end

  describe "#countries_for_decade" do
    let(:decade) { 1970 }

    subject { client.countries_for_decade(decade) }

    context "when grouped by country" do
      it "returns country-to-moods hash" do
        expect_decade_validation(decade)

        vcr("client/countries_for_decade/#{decade}") do
          expect(subject).to_not be_empty

          subject.each do |country, moods|
            expect(country).to be_country_iso_code

            expect(moods).to_not be_empty
            expect(moods).to all be_mood
          end
        end
      end
    end

    context "when grouped by mood" do
      subject { client.countries_for_decade(decade, group_by: :mood) }

      it "returns mood-to-countries hash" do
        vcr("client/countries_for_decade/#{decade}") do
          expect_decade_validation(decade)

          expect(subject).to_not be_empty

          subject.each do |mood, countries|
            expect(mood).to be_mood

            expect(countries).to_not be_empty
            expect(countries).to all be_country_iso_code
          end
        end
      end
    end

    context "when unsupported `group_by` value provided" do
      subject { client.countries_for_decade(decade, group_by: :xyz) }

      it "raises an error" do
        expect_decade_validation(decade)
        expect { subject }.to raise_error(ArgumentError, "invalid `group_by` value: :xyz")
      end
    end

    context "with unknown mood returned" do
      before do
        WebMock.disable_net_connect!(allow: /\/country\/mood/)
      end

      after do
        WebMock.disable_net_connect!
      end

      it "raises an error" do
        stub_request(:get, /\/country\/mood/)
          .to_return(body: {"SLOW" => ["GBR", "FRA"], "XYZ" => ["GBR", "FRA"]}.to_json)

        expect_decade_validation(decade)
        expect { subject }.to raise_error(ArgumentError, "invalid mood: :xyz")
      end
    end
  end
end
