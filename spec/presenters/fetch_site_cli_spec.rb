# frozen_string_literal: true

require "presenters/fetch_site_cli"

RSpec.describe Presenters::FetchSiteCLI do
  describe ".error" do
    subject(:message) { described_class.error(url:, error:) }
    let(:url) { "foo_bar" }

    context "when the error is invalid_url" do
      let(:error) { :invalid_url }

      it "prints the appropriate error to stdout" do
        expect { message }.to output("foo_bar is not a valid url\n").to_stdout
      end
    end

    context "when the error is cannot_open_uri" do
      let(:error) { :cannot_open_uri }

      it "prints the appropriate error to stdout" do
        expect { message }.to output("Unable to connect to foo_bar\n").to_stdout
      end
    end

    context "when the error is an unknown symbol" do
      let(:error) { :foo }

      it "raises a KeyError" do
        expect { message }.to raise_error(KeyError)
      end
    end
  end

  describe ".success" do
    subject(:message) { described_class.success(url:, filename:) }
    let(:url) { "http://example.com" }
    let(:filename) { "example.com.html" }

    it "prints the file saved message to stdout" do
      expect { message }.to output("Saved 'http://example.com' to example.com.html\n").to_stdout
    end
  end
end
