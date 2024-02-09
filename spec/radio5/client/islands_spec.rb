# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Client::Islands do
  let(:client) { Radio5::Client.new }

  describe "#islands" do
    subject { client.islands }

    it "returns list of islands" do
      vcr("client/islands/all") do
        expect(subject.size).to be > 250

        # with large collections it's easier to debug with match per object
        subject.each do |island|
          expect_valid_island(island)
        end
      end
    end
  end

  # TODO: cover all possible variations with fields presence/values

  def expect_valid_island(island)
    expect(island).to match(
      id:              be_mongo_id,
      uuid:            be_uuid,
      api_id:          be_mongo_id.or(be_nil),
      name:            be_filled_string,
      info:            be_filled_string.or(be_nil),
      category:        be_filled_string.or(be_nil),
      favourite_count: be_a(Integer).or(be_nil),
      play_count:      be_a(Integer).or(be_nil),
      rank:            be_a(Integer).or(be_nil),
      icon_url:        be_island_icon_url.or(be_nil),
      splash_url:      be_island_splash_url.or(be_nil),
      marker_url:      be_island_marker_url.or(be_nil),
      enabled:         be_boolean,
      free:            be_boolean.or(be_nil),
      on_map:          be_boolean,
      random:          be_boolean,
      play_mode:       be_filled_string.or(be_nil), # can be: [RANDOM, ONLY_DECADE, nil], not usable for now
      created_at:      be_utc_time,
      created_by:      be_mongo_id,
      updated_at:      be_utc_time.or(be_nil),
      updated_by:      be_mongo_id.or(be_nil)
    )
  end
end
