# frozen_string_literal: true

module Presenters
  class FetchSiteCLI
    ERROR_MESSAGES = {
      invalid_url: "? is not a valid url",
      cannot_open_uri: "Unable to connect to ?"
    }.freeze

    private_constant :ERROR_MESSAGES

    def self.error(error:, url:)
      puts ERROR_MESSAGES.fetch(error).sub("?", url)
    end

    def self.success(url:, filename:)
      puts "Saved '#{url}' to #{filename}"
    end
  end
end
