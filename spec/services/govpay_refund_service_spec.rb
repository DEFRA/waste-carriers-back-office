# frozen_string_literal: true

require "webmock/rspec"
require "rails_helper"

RSpec.describe GovpayRefundService do
  subject(:govpay_refund) { described_class.run(payment: payment, amount: amount) }

  let(:payment) { registration.finance_details.payments.first }
  let(:amount) { 1 }
  let(:registration) { create(:registration) }
  let(:refund_response) { :get_refund_response_submitted }

  let(:back_office_api_token) { "a_back_office_api_token" }
  let(:front_office_api_token) { "a_front_office_api_token" }
  let(:govpay_api_token) { back_office_api_token }

  before do
    allow(DefraRubyGovpay.configuration).to receive_messages(
      host_is_back_office: true,
      govpay_back_office_api_token: back_office_api_token,
      govpay_front_office_api_token: front_office_api_token
    )

    payment.update!(govpay_id: "govpay123", payment_type: "GOVPAY", moto: true)

    stub_const("DefraRubyGovpayAPI", DefraRubyGovpay::API.new)

    # retrieve a payment's details
    stub_request(:get, %r{\A.*?/v1/payments/#{payment.govpay_id}\z})
      .with(headers: { "Authorization" => "Bearer #{govpay_api_token}" })
      .to_return(
        status: 200,
        body: file_fixture("govpay/get_payment_response_success.json")
      )

    # requesting a refund
    stub_request(:post, %r{\A.*?/v1/payments/#{payment.govpay_id}/refunds\z})
      .with(headers: { "Authorization" => "Bearer #{govpay_api_token}" })
      .to_return(
        status: 200,
        body: file_fixture("govpay/#{refund_response}.json")
      )

  end

  describe ".run" do
    context "when the request is valid" do
      it "returns a Refund object with 'submitted' status" do
        expect(govpay_refund.class).to eq DefraRubyGovpay::Refund
        expect(govpay_refund.submitted?).to be true
      end
    end

    context "when a non-MOTO payment is refunded from the back office" do
      # host_is_back_office is true, but need to stub the request with the front office API token
      let(:govpay_api_token) { front_office_api_token }

      before do
        allow(Rails.configuration).to receive(:govpay_front_office_api_token).and_return(govpay_api_token)
        payment.update!(moto: false)
      end

      it "uses the front-office API token and returns a response with 'submitted' status" do
        expect(govpay_refund.submitted?).to be true
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
        stub_request(:get, %r{\A.*?/payments/#{payment.govpay_id}\z}).to_return(status: 500)
        allow(Airbrake).to receive(:notify)
      end

      it "notifies Airbrake" do
        govpay_refund
      rescue StandardError
        expect(Airbrake).to have_received(:notify).with(DefraRubyGovpay::GovpayApiError,
                                                        hash_including(message: "Error in Govpay refund service", govpay_id: payment.govpay_id))
      end
    end

    context "when the refund request to Govpay fails" do
      before do
        stub_request(:post, %r{\A.*?/payments/#{payment.govpay_id}/refunds\z}).to_return(status: 500)
        allow(Airbrake).to receive(:notify)
      end

      it "notifies Airbrake" do
        govpay_refund
      rescue StandardError
        expect(Airbrake).to have_received(:notify).with(DefraRubyGovpay::GovpayApiError,
                                                        hash_including(message: "Error in Govpay refund service", govpay_id: payment.govpay_id))
      end
    end
  end
end
