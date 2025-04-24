# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Client::Countries do
  include ValidationsHelper

  let(:client) { Radio5::Client.new }

  describe "#countries" do
    subject(:countries) { client.countries }

    it "returns countries hash" do
      vcr("client/countries/en") do
        expect(countries.size).to be > 200

        countries.each do |iso_code, country|
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

    subject(:countries_for_decade) { client.countries_for_decade(decade) }

    context "when grouped by country" do
      it "returns country-to-moods hash" do
        expect_decade_validation(decade)

        vcr("client/countries_for_decade/#{decade}") do
          expect(countries_for_decade).not_to be_empty

          countries_for_decade.each do |country, moods|
            expect(country).to be_country_iso_code

            expect(moods).not_to be_empty
            expect(moods).to all be_mood
          end
        end
      end
    end

    context "when grouped by mood" do
      subject(:countries_for_decade) { client.countries_for_decade(decade, group_by: :mood) }

      it "returns mood-to-countries hash" do
        vcr("client/countries_for_decade/#{decade}") do
          expect_decade_validation(decade)

          expect(countries_for_decade).not_to be_empty

          countries_for_decade.each do |mood, countries|
            expect(mood).to be_mood

            expect(countries).not_to be_empty
            expect(countries).to all be_country_iso_code
          end
        end
      end
    end

    context "when unsupported `group_by` value provided" do
      subject(:countries_for_decade) { client.countries_for_decade(decade, group_by: :xyz) }

      it "raises an error" do
        expect_decade_validation(decade)
        expect { countries_for_decade }.to raise_error(ArgumentError, "invalid `group_by` value: :xyz")
      end
    end
  end
end
