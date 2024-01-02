# frozen_string_literal: true

require "vcr"

DEFAULT_CASSETTE_OPTS = {
  match_requests_on: [:uri, :method, :body, :headers],
  allow_unused_http_interactions: false
}

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr"
  c.hook_into :webmock
end

if ENV["IGNORE_VCR"]
  WebMock.allow_net_connect!
  VCR.turn_off!(ignore_cassettes: true)
end

def vcr(path, opts = {})
  VCR.use_cassette(path, DEFAULT_CASSETTE_OPTS.merge(opts)) do
    yield
  end
end
