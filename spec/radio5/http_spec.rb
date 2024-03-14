# frozen_string_literal: true

require "spec_helper"

RSpec.describe Radio5::Http do
  let(:host) { "host.com" }
  let(:port) { 443 }

  describe "#new" do
    context "with default config" do
      subject(:http) { described_class.new(host: host, port: port) }

      it "assigns default values" do
        expect(http).to have_attributes(
          host: host,
          port: port,
          open_timeout: described_class::DEFAULT_OPEN_TIMEOUT,
          read_timeout: described_class::DEFAULT_READ_TIMEOUT,
          write_timeout: described_class::DEFAULT_WRITE_TIMEOUT,
          proxy_url: described_class::DEFAULT_PROXY_URL,
          proxy_uri: nil,
          max_retries: described_class::DEFAULT_MAX_RETRIES,
          debug_output: described_class::DEFAULT_DEBUG_OUTPUT
        )
      end
    end

    context "with custom config" do
      subject(:http) do
        described_class.new(
          host: host,
          port: port,
          open_timeout: 20,
          read_timeout: 30,
          write_timeout: 40,
          proxy_url: "http://user:password@proxy.com:80",
          debug_output: $stdout
        )
      end

      it "assigns user values" do
        expect(http).to have_attributes(
          host: host,
          port: port,
          open_timeout: 20,
          read_timeout: 30,
          write_timeout: 40,
          proxy_url: "http://user:password@proxy.com:80",
          debug_output: $stdout
        )

        expect(http.proxy_uri).to be_a(URI)
        expect(http.proxy_uri).to have_attributes(
          scheme: "http",
          host: "proxy.com",
          port: 80,
          user: "user",
          password: "password"
        )
      end
    end

    context "with invalid proxy URL" do
      subject(:http) { described_class.new(host: host, port: port, proxy_url: "xyz") }

      it "raises an error" do
        expect { http }.to raise_error(
          ArgumentError,
          "Invalid proxy URL: \"xyz\", parsed URI: #<URI::Generic xyz>"
        )
      end
    end
  end

  describe "#request" do
    let(:http) { described_class.new(host: host, port: port, max_retries: 2) }
    let(:path) { "/path" }

    subject(:request) { http.request(Net::HTTP::Get, path, {}, nil, {}) }

    context "when retriable error happens" do
      before do
        WebMock.disable_net_connect!(allow: /#{Regexp.escape(path)}/)
      end

      after do
        WebMock.disable_net_connect!
      end

      it "makes specified number of retries" do
        stub_request(:get, /#{Regexp.escape(host)}#{Regexp.escape(path)}/).to_timeout

        expect(http).to receive(:make_request).exactly(4).and_call_original
        expect { request }.to raise_error(Net::OpenTimeout)
      end
    end

    context "when user error happens" do
      it "raises an error immidiately" do
        allow(http.http_client).to receive(:request).and_raise(StandardError, "Some error")

        expect(http).to receive(:make_request).once.and_call_original
        expect { request }.to raise_error(StandardError, "Some error")
      end
    end
  end
end
