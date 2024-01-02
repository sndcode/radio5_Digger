# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Client::Islands do
  let(:client) { Radio5::Client.new }

  describe "#islands" do
    subject { client.islands }

    # rubocop:disable Layout/HashAlignment
    it "returns list of islands" do
      vcr("client/islands/all") do
        expect(subject.size).to be > 250
        expect(subject).to all match(
          id:              be_filled_string,
          uuid:            be_filled_string,
          api_id:          be_filled_string.or(be_nil),
          name:            be_filled_string,
          info:            be_a_kind_of(String).or(be_nil),
          category:        be_filled_string.or(be_nil),
          favourite_count: be_a_kind_of(Integer).or(be_nil),
          play_count:      be_a_kind_of(Integer).or(be_nil),
          rank:            be_a_kind_of(Integer).or(be_nil),
          icon_url:        be_filled_string.or(be_nil),
          splash_url:      be_filled_string.or(be_nil),
          marker_url:      be_filled_string.or(be_nil),
          enabled:         be_boolean,
          free:            be_boolean.or(be_nil),
          on_map:          be_boolean,
          random:          be_boolean,
          play_mode:       be_filled_string.or(be_nil),
          created_at:      be_a_kind_of(Time),
          created_by:      be_filled_string,
          modified_at:     be_a_kind_of(Time).or(be_nil),
          modified_by:     be_filled_string.or(be_nil)
        )
      end
    end
    # rubocop:enable Layout/HashAlignment
  end
end
