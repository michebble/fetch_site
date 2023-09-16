# frozen_string_literal: true

require_relative "services/fetch_site"
require_relative "presenters/fetch_site_cli"

class App
  def initialize(fetch_site_service: Services::FetchSite, fetch_site_presenter: Presenters::FetchSiteCLI)
    @fetch_site_service = fetch_site_service
    @fetch_site_presenter = fetch_site_presenter
  end

  def fetch_site(urls)
    urls.each do |url|
      case fetch_site_service.new(url:).call
      in :ok, filename then fetch_site_presenter.success(url:, filename:)
      in :error, error then fetch_site_presenter.error(url:, error:)
      end
    end
  end

  private

  attr_reader :fetch_site_service, :fetch_site_presenter
end
