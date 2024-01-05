# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Client::Islands do
  let(:client) { Radio5::Client.new }

  describe "#islands" do
    subject { client.islands }

    # rubocop:disable Layout/HashAlignment, RSpec/IteratedExpectation
    it "returns list of islands" do
      vcr("client/islands/all") do
        expect(subject.size).to be > 250

        # with large collections it's easier to debug with match per object
        subject.each do |island|
          expect(island).to match(
            id:              be_mongo_id,
            uuid:            be_uuid,
            api_id:          be_mongo_id.or(be_nil),
            name:            be_filled_string,
            info:            be_filled_string.or(be_nil),
            category:        be_filled_string.or(be_nil),
            favourite_count: be_a_kind_of(Integer).or(be_nil),
            play_count:      be_a_kind_of(Integer).or(be_nil),
            rank:            be_a_kind_of(Integer).or(be_nil),
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
    end
    # rubocop:enable Layout/HashAlignment, RSpec/IteratedExpectation
  end
end
