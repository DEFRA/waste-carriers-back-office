# frozen_string_literal: true

require "webmock/rspec"
require "rails_helper"

RSpec.describe GovpayRefundService do
  subject(:govpay_refund) { described_class.run(payment: payment, amount: amount) }

  let(:payment) { registration.finance_details.payments.first }
  let(:amount) { 1 }

  let(:govpay_host) { "https://publicapi.payments.service.gov.uk" }
  let(:registration) { create(:registration) }

  let(:refund_response) { :get_refund_response_success }
  let(:back_office_api_token) { "back_office_token" }
  let(:govpay_api_token) { back_office_api_token }

  before do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:govpay_payments).and_return(true)
    allow(WasteCarriersEngine.configuration).to receive(:host_is_back_office?).and_return(true)
    allow(Rails.configuration).to receive(:govpay_url).and_return(govpay_host)
    allow(Rails.configuration).to receive(:govpay_back_office_api_token).and_return(back_office_api_token)
    payment.update!(govpay_id: "govpay123", payment_type: "GOVPAY", moto: true)

    # retrieve a payment's details
    stub_request(:get, "#{govpay_host}/payments/#{payment.govpay_id}")
      .with(headers: { "Authorization" => "Bearer #{govpay_api_token}" })
      .to_return(
        status: 200,
        body: file_fixture("govpay/get_payment_response_success.json")
      )

    # requesting a refund
    stub_request(:post, "#{govpay_host}/payments/#{payment.govpay_id}/refunds")
      .with(headers: { "Authorization" => "Bearer #{govpay_api_token}" })
      .to_return(
        status: 200,
        body: file_fixture("govpay/#{refund_response}.json")
      )
  end

  describe ".run" do
    context "when the request is valid" do
      it "returns a successful Refund object" do
        expect(govpay_refund.class).to eq WasteCarriersEngine::Govpay::Refund
        expect(govpay_refund.success?).to be true
      end
    end

    context "when a non-MOTO payment is refunded from the back office" do
      # This ensures that the Govpay API is not stubbed for the back office bearer token,
      # so the spec will fail if the request is made using the back office token.
      let(:govpay_api_token) { "front_office_token" }

      before do
        allow(Rails.configuration).to receive(:govpay_front_office_api_token).and_return(govpay_api_token)
        payment.update!(moto: false)
      end

      it "uses the front-office API token and returns success" do
        expect(govpay_refund.success?).to be true
      end
    end

    context "when the request is invalid" do
      context "when the amount to refund is higher than available" do
        let(:amount) { 300_000 }

        it { expect(govpay_refund).to be false }
      end

      context "when the refund was unsuccessful" do
        let(:refund_response) { :get_refund_response_unsuccessful }

        it { expect(govpay_refund).to be false }
      end
    end

    context "when the payment details request to Govpay fails" do
      before do
        stub_request(:get, "#{govpay_host}/payments/#{payment.govpay_id}").to_return(status: 500)
        allow(Airbrake).to receive(:notify)
      end

      it "notifies Airbrake" do
        govpay_refund
      rescue StandardError
        expect(Airbrake).to have_received(:notify).with(RestClient::InternalServerError,
                                                        hash_including(message: "Error sending govpay request", path: "/payments/#{payment.govpay_id}"))
        expect(Airbrake).to have_received(:notify).with(WasteCarriersEngine::GovpayApiError,
                                                        hash_including(message: "Error in Govpay refund service", govpay_id: payment.govpay_id))
      end
    end

    context "when the refund request to Govpay fails" do
      before do
        stub_request(:post, "#{govpay_host}/payments/#{payment.govpay_id}/refunds").to_return(status: 500)
        allow(Airbrake).to receive(:notify)
      end

      it "notifies Airbrake" do
        govpay_refund
      rescue StandardError
        expect(Airbrake).to have_received(:notify).with(RestClient::InternalServerError,
                                                        hash_including(message: "Error sending govpay request", path: "/payments/#{payment.govpay_id}/refunds"))
        expect(Airbrake).to have_received(:notify).with(WasteCarriersEngine::GovpayApiError,
                                                        hash_including(message: "Error in Govpay refund service", govpay_id: payment.govpay_id))
      end
    end
  end
end
