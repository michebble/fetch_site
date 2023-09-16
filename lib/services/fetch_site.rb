# frozen_string_literal: true

require "open-uri"
require "fileutils"
require "tempfile"

module Services
  class FetchSite
    Result = Data.define(:response, :value)

    OPPERATIONS = %i[
      create_uri
      open_uri
      persist_file
    ].freeze

    ROOT_PATH = File.expand_path(".").freeze

    private_constant :OPPERATIONS, :ROOT_PATH

    def initialize(url:)
      @url = url
    end

    def call
      OPPERATIONS.reduce(@url) do |acc, opperation|
        case acc
        in String => url then send(opperation, url)
        in :ok, value then send(opperation, value)
        else acc end
      end
    end

    private

    def create_uri(url)
      uri = URI.parse(url)
      if uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
        Result[:ok, uri]
      else
        Result[:error, :invalid_url]
      end
    end

    def open_uri(uri)
      file = Tempfile.new
      uri.open { |u| u.each_line { |line| file.write(line) } }
      file.rewind
      Result[:ok, {file:, uri:}]
    rescue SocketError => _e
      file.close
      file.unlink
      Result[:error, :cannot_open_uri]
    end

    def persist_file(value)
      value => uri:, file:
      filename = "#{uri.host}.html"
      FileUtils.mv(file.path, File.join(ROOT_PATH, filename))
      Result[:ok, filename]
    ensure
      file.close
      file.unlink
    end
  end
end
