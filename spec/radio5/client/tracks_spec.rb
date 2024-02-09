# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Client::Tracks do
  include ValidationsHelper

  let(:client) { Radio5::Client.new }

  describe "#track" do
    subject { client.track(track_id) }

    context "when track found" do
      let(:track_id) { "5d330a4506fb03d8872a333d" }

      it "returns track info" do
        vcr("client/track/found") do
          expect_track_id_validation(track_id)
          expect_valid_track(subject)
        end
      end
    end

    context "when track not found" do
      let(:track_id) { "5d330a4506fb03d887233333" }

      it "returns nil" do
        vcr("client/track/not_found") do
          expect_track_id_validation(track_id)
          expect(subject).to be_nil
        end
      end
    end
  end

  describe "#random_track" do
    subject { client.random_track }

    context "when matching track found" do
      it "returns track info" do
        expect_country_iso_codes_validation([])
        expect_decades_validation([])
        expect_moods_validation(Radio5::Constants::MOODS)

        vcr("client/random_track/found") do
          expect_valid_track(subject)
        end
      end
    end

    context "when matching track not found" do
      let(:country) { "KN1" }
      let(:decades) { [1920, 1930] }
      let(:moods) { [:slow, :weird] }

      subject { client.random_track(country: country, decades: decades, moods: moods) }

      it "returns nil" do
        expect_country_iso_codes_validation([country])
        expect_decades_validation(decades)
        expect_moods_validation(moods)

        vcr("client/random_track/not_found") do
          expect(subject).to be_nil
        end
      end
    end
  end

  describe "#island_track" do
    let(:island_id) { "5d330a3e06fb03d8872a330d" }

    subject { client.island_track(island_id: island_id) }

    context "when matching track found" do
      it "returns track info" do
        expect_island_id_validation(island_id)
        expect_moods_validation(Radio5::Constants::MOODS)

        vcr("client/island_track/found") do
          expect_valid_track(subject)
        end
      end
    end

    context "when matching track not found" do
      let(:moods) { [:weird] }

      subject { client.island_track(island_id: island_id, moods: moods) }

      it "returns nil" do
        expect_island_id_validation(island_id)
        expect_moods_validation(moods)

        vcr("client/island_track/not_found") do
          expect(subject).to be_nil
        end
      end
    end
  end

  # TODO: cover all possible variations with fields presence/values

  def expect_valid_track(track)
    expect(track).to include(
      id:         be_mongo_id,
      uuid:       be_uuid,
      artist:     be_filled_string,
      title:      be_filled_string,
      album:      be_filled_string.or(be_nil),
      year:       be_filled_string.or(be_nil),
      label:      be_filled_string.or(be_nil),
      songwriter: be_filled_string.or(be_nil),
      length:     be_a(Integer),
      info:       be_filled_string.or(be_nil),

      cover_url: match(
        thumb:  be_track_cover_url(:thumb),
        small:  be_track_cover_url(:small),
        medium: be_track_cover_url(:medium),
        large:  be_track_cover_url(:large)
      ).or(be_nil),

      audio: match(
        mpeg: match(
          url:        be_mpeg_url,
          expires_at: be_utc_time
        ),
        ogg: match(
          url:        be_ogg_url,
          expires_at: be_utc_time
        )
      ),

      decade:     be_decade,
      mood:       be_mood,
      country:    be_country_iso_code,
      like_count: be_a(Integer),
      created_at: be_utc_time.or(be_nil),
      created_by: be_mongo_id
    )
  end
end
