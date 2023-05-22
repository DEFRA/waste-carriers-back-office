# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe GovpayRefundDetailsService do

    describe "#run" do

      let(:govpay_host) { "https://publicapi.payments.service.gov.uk" }
      let(:registration) { create(:registration, finance_details: build(:finance_details, :has_overpaid_order_and_payment_govpay)) }
      let(:original_payment) { registration.finance_details.payments.first }
      let(:govpay_payment_id) { original_payment.govpay_id }
      let(:refund) { build(:payment, :govpay_refund_pending, refunded_payment_govpay_id: original_payment.govpay_id) }
      let(:govpay_refund_id) { refund.govpay_id }

      before do
        allow(Rails.configuration).to receive(:govpay_url).and_return(govpay_host)
        registration.finance_details.payments << refund
      end

      subject(:run_service) { described_class.new.run(refund_id: refund_id) }

      context "with an invalid refund id" do

        let(:refund_id) { "bad_id" }

        before { allow(Airbrake).to receive(:notify) }

        it "raises an exception" do
          expect { run_service }.to raise_exception(ArgumentError)
        end

        it "notifies Airbrake" do
          run_service
        rescue StandardError
          expect(Airbrake).to have_received(:notify).with(ArgumentError, anything)
        end
      end

      context "with a valid refund id" do
        let(:refund_id) { refund.govpay_id }

        context "when the govpay request succeeds" do
          before do
            stub_request(:get, %r{.*#{govpay_host}/payments/#{govpay_payment_id}/refunds/#{govpay_refund_id}})
              .to_return(status: 200, body: File.read("./spec/fixtures/files/govpay/get_refund_details_response_submitted.json"))
          end

          it "returns the expected status" do
            expect(run_service["status"]).to eq "submitted"
          end
        end

        context "when the govpay request fails" do
          before do
            stub_request(:get, %r{.*#{govpay_host}/payments/#{govpay_payment_id}/refunds/#{govpay_refund_id}})
              .to_return(status: 500)
            allow(Airbrake).to receive(:notify)
          end

          it "raises an exception" do
            expect { run_service }.to raise_exception(WasteCarriersEngine::GovpayApiError)
          end

          it "notifies Airbrake" do
            run_service
          rescue GovpayApiError
            expect(Airbrake).to have_received(:notify)
              .with(RestClient::InternalServerError,
                    hash_including(
                      message: "Error sending govpay request",
                      path: "/payments/#{govpay_payment_id}/refunds/#{govpay_refund_id}"
                    ))
          end
        end
      end
    end
  end
end
