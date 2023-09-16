# frozen_string_literal: true

require "services/fetch_site"

RSpec.describe Services::FetchSite do
  subject(:result) { described_class.new(url:).call }

  let(:url) { "http://example.com" }

  after(:each) do
    if File.exist?("example.com.html")
      File.delete("example.com.html")
    end
  end

  it "persists a file with the url contents" do
    VCR.use_cassette("example.com") do
      expect(result.response).to be :ok
      expect(result.value).to eq "example.com.html"
      expect(File.exist?("example.com.html")).to be true
      expect(File.read("example.com.html")).to eq(
        <<~MULTILINE_STRING
          <!doctype html>
          <html>
          <head>
              <title>Example Domain</title>

              <meta charset="utf-8" />
              <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
              <meta name="viewport" content="width=device-width, initial-scale=1" />
              <style type="text/css">
              body {
                  background-color: #f0f0f2;
                  margin: 0;
                  padding: 0;
                  font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
              }
              div {
                  width: 600px;
                  margin: 5em auto;
                  padding: 2em;
                  background-color: #fdfdff;
                  border-radius: 0.5em;
                  box-shadow: 2px 3px 7px 2px rgba(0,0,0,0.02);
              }
              a:link, a:visited {
                  color: #38488f;
                  text-decoration: none;
              }
              @media (max-width: 700px) {
                  div {
                      margin: 0 auto;
                      width: auto;
                  }
              }
              </style>
          </head>

          <body>
          <div>
              <h1>Example Domain</h1>
              <p>This domain is for use in illustrative examples in documents. You may use this
              domain in literature without prior coordination or asking for permission.</p>
              <p><a href="https://www.iana.org/domains/example">More information...</a></p>
          </div>
          </body>
          </html>
        MULTILINE_STRING
      )
    end
  end

  context "when the url is not a valid uri" do
    let(:url) { "foo@example.com" }

    it "returns an error" do
      expect(result.response).to be :error
      expect(result.value).to be :invalid_url
      expect(File.exist?("foo@example.com.html")).to be false
    end
  end

  context "when the url is a malformed uri" do
    let(:url) { "http://example" }

    it "returns an error" do
      expect(result.response).to be :error
      expect(result.value).to be :cannot_open_uri
      expect(File.exist?("example.html")).to be false
    end
  end
end
