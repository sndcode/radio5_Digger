# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Client::Users do
  include ValidationsHelper

  let(:client) { Radio5::Client.new }

  describe "#user" do
    subject { client.user(user_id) }

    context "when user found" do
      let(:user_id) { "5d3306de06fb03d8871fd138" }

      it "returns user info" do
        vcr("client/user/found") do
          expect_user_id_validation(user_id)
          expect_valid_user(subject)
        end
      end
    end

    context "when user not found" do
      let(:user_id) { "5d3306de06fb03d8871fd112" }

      it "returns nil" do
        vcr("client/user/not_found") do
          expect_user_id_validation(user_id)
          expect(subject).to be_nil
        end
      end
    end
  end

  describe "#user_tracks" do
    subject { client.user_tracks(user_id) }

    context "when user exists" do
      let(:user_id) { "5d3306de06fb03d8871fd138" }

      context "with default page size" do
        it "returns all tracks" do
          expect_user_id_validation(user_id)
          expect_user_track_status_validation(:on_air)
          expect_page_size_validation(Radio5::Constants::MAX_PAGE_SIZE)
          expect_page_number_validation(1)

          vcr("client/user_tracks/user_found") do
            expect(subject.size).to be > 500
            subject.each { |track| expect_valid_user_track(track) }
          end
        end
      end

      context "with additional filters" do
        let(:status) { :duplicate }
        let(:size) { 3 }
        let(:page) { 2 }

        subject { client.user_tracks(user_id, status: status, size: size, page: page) }

        it "returns selected tracks" do
          expect_user_id_validation(user_id)
          expect_user_track_status_validation(status)
          expect_page_size_validation(size)
          expect_page_number_validation(page)

          vcr("client/user_tracks/user_found_plus_filters") do
            expect(subject.size).to eq 3
            subject.each { |track| expect_valid_user_track(track) }
          end
        end
      end
    end

    context "when user does not exist" do
      let(:user_id) { "5d3306de06fb03d8871fd112" }

      it "returns empty array" do
        expect_user_id_validation(user_id)
        expect_user_track_status_validation(:on_air)
        expect_page_size_validation(Radio5::Constants::MAX_PAGE_SIZE)
        expect_page_number_validation(1)

        vcr("client/user_tracks/user_not_found") do
          expect(subject).to eq []
        end
      end
    end
  end

  describe "#user_follow_counts" do
    subject { client.user_follow_counts(user_id) }

    context "when user exists" do
      let(:user_id) { "5d3306de06fb03d8871fd138" }

      it "returns correct hash" do
        expect_user_id_validation(user_id)

        vcr("client/user_follow_counts/user_found") do
          expect(subject).to match(
            followings: be_positive_number,
            followers: be_positive_number
          )
        end
      end
    end

    context "when user does not exist" do
      let(:user_id) { "5d3306de06fb03d8871fd112" }

      it "returns correct hash" do
        expect_user_id_validation(user_id)

        vcr("client/user_follow_counts/user_not_found") do
          expect(subject).to match(
            followings: 0,
            followers: 0
          )
        end
      end
    end
  end

  describe "#user_followers" do
    subject { client.user_followers(user_id) }

    context "when user exists" do
      let(:user_id) { "5d3306de06fb03d8871fd138" }

      context "with default page size" do
        it "returns all tracks" do
          expect_user_id_validation(user_id)
          expect_page_size_validation(Radio5::Constants::MAX_PAGE_SIZE)
          expect_page_number_validation(1)

          vcr("client/user_followers/user_found") do
            expect(subject.size).to be > 800
            subject.each { |user| expect_valid_follow_user(user) }
          end
        end
      end

      context "with additional filters" do
        let(:size) { 3 }
        let(:page) { 2 }

        subject { client.user_followers(user_id, size: size, page: page) }

        it "returns selected tracks" do
          expect_user_id_validation(user_id)
          expect_page_size_validation(size)
          expect_page_number_validation(page)

          vcr("client/user_followers/user_found_plus_filters") do
            expect(subject.size).to eq 3
            subject.each { |user| expect_valid_follow_user(user) }
          end
        end
      end
    end

    context "when user does not exist" do
      let(:user_id) { "5d3306de06fb03d8871fd112" }

      it "returns empty array" do
        expect_user_id_validation(user_id)
        expect_page_size_validation(Radio5::Constants::MAX_PAGE_SIZE)
        expect_page_number_validation(1)

        vcr("client/user_followers/user_not_found") do
          expect(subject).to eq []
        end
      end
    end
  end

  describe "#user_followings" do
    subject { client.user_followings(user_id) }

    context "when user exists" do
      let(:user_id) { "5d3306de06fb03d8871fd138" }

      context "with default page size" do
        it "returns all tracks" do
          expect_user_id_validation(user_id)
          expect_page_size_validation(Radio5::Constants::MAX_PAGE_SIZE)
          expect_page_number_validation(1)

          vcr("client/user_followings/user_found") do
            expect(subject.size).to be > 10
            subject.each { |user| expect_valid_follow_user(user) }
          end
        end
      end

      context "with additional filters" do
        let(:size) { 3 }
        let(:page) { 2 }

        subject { client.user_followers(user_id, size: size, page: page) }

        it "returns selected tracks" do
          expect_user_id_validation(user_id)
          expect_page_size_validation(size)
          expect_page_number_validation(page)

          vcr("client/user_followings/user_found_plus_filters") do
            expect(subject.size).to eq 3
            subject.each { |user| expect_valid_follow_user(user) }
          end
        end
      end
    end

    context "when user does not exist" do
      let(:user_id) { "5d3306de06fb03d8871fd112" }

      it "returns empty array" do
        expect_user_id_validation(user_id)
        expect_page_size_validation(Radio5::Constants::MAX_PAGE_SIZE)
        expect_page_number_validation(1)

        vcr("client/user_followings/user_not_found") do
          expect(subject).to eq []
        end
      end
    end
  end

  describe "#user_liked_tracks" do
    subject { client.user_liked_tracks }

    it "raises an error" do
      expect { subject }.to raise_error(NotImplementedError, "depends on auth")
    end
  end

  describe described_class::Parser do
    describe "#normalize_year" do
      it "returns correct year according to offset" do
        examples = {
          Time.new(1990, 1, 1, 5, 1, 1, 0) => 1990,
          Time.new(1990, 2, 1, 5, 1, 1, 0) => 1990,
          Time.new(1989, 12, 31, 23, 1, 1, 0) => 1990
        }

        examples.each do |time, expected_year|
          year = described_class.normalize_year(time)
          expect(year).to eq expected_year
        end
      end
    end
  end

  # TODO: cover all possible variations with fields presence/values

  def expect_valid_user(user)
    expect(user).to match(
      id:      be_mongo_id,
      uuid:    be_uuid,
      name:    be_filled_string.or(be_nil),
      info:    be_filled_string.or(be_nil),
      country: be_country_iso_code.or(be_nil),
      rank:    be_a(Integer),

      image_url: match(
        icon:   be_user_image_url(:icon),
        thumb:  be_user_image_url(:thumb),
        small:  be_user_image_url(:small),
        medium: be_user_image_url(:medium),
        large:  be_user_image_url(:large)
      ).or(be_nil),

      birthday: match(
        time:            be_utc_time,
        year_normalized: be_a(Integer)
      ).or(be_nil),

      created_at: be_utc_time
    )
  end

  def expect_valid_follow_user(user)
    expect(user).to match(
      id:      be_mongo_id,
      name:    be_filled_string.or(be_nil),
      country: be_country_iso_code.or(be_nil),
      rank:    be_a(Integer),

      image_url: match(
        icon:   be_user_image_url(:icon),
        thumb:  be_user_image_url(:thumb),
        small:  be_user_image_url(:small),
        medium: be_user_image_url(:medium),
        large:  be_user_image_url(:large)
      ).or(be_nil),

      created_at: be_utc_time
    )
  end

  def expect_valid_user_track(track)
    expect(track).to match(
      id:     be_mongo_id,
      uuid:   be_uuid,
      artist: be_filled_string,
      title:  be_filled_string,
      year:   be_filled_string.or(be_nil),

      cover_url: match(
        thumb:  be_track_cover_url(:thumb),
        small:  be_track_cover_url(:small),
        medium: be_track_cover_url(:medium),
        large:  be_track_cover_url(:large)
      ).or(be_nil),

      decade:     be_decade,
      country:    be_country_iso_code,
      like_count: be_a(Integer),
      status:     be_user_track_status
    )
  end
end
