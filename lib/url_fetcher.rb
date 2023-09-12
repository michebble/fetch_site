require "open-uri"

class UrlFetcher
  def initialize(url:)
    @url = url
    @uri = URI.parse(url)
  end

  def process
    return "#{url} is not a valid url" if !valid_url?
    begin
      File.open("#{uri.host}.html", "w") do |output|
        URI.open(url) {|f|
          f.each_line { |line| output.write(line) }
        }
      end
      return "fecthed #{url}"
    rescue SocketError => e
      puts "Unable to connect to #{url}"
      puts "Check url is correct and try again"
      puts e.inspect
    end
  end

  private

  attr_reader :url, :uri

  def valid_url?
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  end

end
