require "app"

RSpec.describe App do
  describe ".fetch_site" do
    subject(:fetch_site) do
      described_class.new(
        fetch_site_service:,
        fetch_site_presenter:
      ).fetch_site(urls)
    end

    let(:fetch_site_service) { double("FetchSiteServiceDouble", new: fetch_site_service_instance) }
    let(:fetch_site_service_instance) { double("FetchSiteServiceInstanceDouble") }
    let(:fetch_site_presenter) { double("FetchSitePresenterDouble", success: true, error: true) }

    context "called with one url" do
      let(:urls) { ["test"] }

      context "when the service suceeds" do
        let(:service_result) { [:ok, "test file name"] }

        it "calls the service and presenter" do
          expect(fetch_site_service_instance).to receive(:call).and_return(service_result)
          expect(fetch_site_presenter).to receive(:success).with(url: "test", filename: "test file name")
          fetch_site
        end
      end

      context "when the service fails" do
        let(:service_result) { [:error, :error_message] }

        it "calls the service and presenter" do
          expect(fetch_site_service_instance).to receive(:call).and_return(service_result)
          expect(fetch_site_presenter).to receive(:error).with(url: "test", error: :error_message)
          fetch_site
        end
      end
    end

    context "called with multiple urls" do
      let(:urls) { ["test1", "test2"] }

      context "when the service suceeds" do
        let(:service_result1) { [:ok, "test1 file name"] }
        let(:service_result2) { [:ok, "test2 file name"] }

        it "calls the service and presenter" do
          expect(fetch_site_service_instance).to receive(:call).and_return(service_result1)
          expect(fetch_site_presenter).to receive(:success).once.with(url: "test1", filename: "test1 file name")
          expect(fetch_site_service_instance).to receive(:call).and_return(service_result2)
          expect(fetch_site_presenter).to receive(:success).once.with(url: "test2", filename: "test2 file name")
          fetch_site
        end
      end

      context "when the first service fails" do
        let(:service_result1) { [:error, :error_message] }
        let(:service_result2) { [:ok, "test2 file name"] }

        it "calls the service and presenter" do
          expect(fetch_site_service_instance).to receive(:call).and_return(service_result1)
          expect(fetch_site_presenter).to receive(:error).once.with(url: "test1", error: :error_message)
          expect(fetch_site_service_instance).to receive(:call).and_return(service_result2)
          expect(fetch_site_presenter).to receive(:success).once.with(url: "test2", filename: "test2 file name")
          fetch_site
        end
      end
    end
  end
end
