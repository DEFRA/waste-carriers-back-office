# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe GovpayRefundDetailsService do

    describe "#run" do

      let(:registration) { create(:registration, finance_details: build(:finance_details, :has_overpaid_order_and_payment_govpay)) }
      let(:original_payment) { registration.finance_details.payments.first }
      let(:govpay_payment_id) { original_payment.govpay_id }
      let(:refund) { build(:payment, :govpay_refund_pending, refunded_payment_govpay_id: original_payment.govpay_id) }
      let(:govpay_refund_id) { refund.govpay_id }

      let(:back_office_api_token) { "a_back_office_api_token" }
      let(:front_office_api_token) { "a_front_office_api_token" }
      let(:govpay_api_token) { back_office_api_token }

      before do
        allow(DefraRubyGovpay.configuration).to receive_messages(
          host_is_back_office: true,
          govpay_back_office_api_token: back_office_api_token,
          govpay_front_office_api_token: front_office_api_token
        )

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
            stub_request(:get, %r{\A.*?/v1/payments/#{govpay_payment_id}/refunds/#{govpay_refund_id}\z})
              .with(
                headers: {
                  "Authorization" => "Bearer #{govpay_api_token}",
                  "Content-Type" => "application/json"
                }
              ).to_return(status: 200, body: File.read("./spec/fixtures/files/govpay/get_refund_details_response_submitted.json"))
          end

          context "with a non-MOTO payment" do
            # host_is_back_office is true, but need to stub the request with the front office API token
            let(:govpay_api_token) { front_office_api_token }

            before { original_payment.update!(moto: false) }

            it "returns the expected status" do
              expect(run_service["status"]).to eq "submitted"
            end
          end

          context "with a MOTO payment" do
            before { original_payment.update(moto: true) }

            it "returns the expected status" do
              expect(run_service["status"]).to eq "submitted"
            end
          end
        end

        context "when the govpay request fails" do
          before do
            stub_request(:get, %r{\A.*?/v1/payments/#{govpay_payment_id}/refunds/#{govpay_refund_id}\z})
              .to_return(status: 500)
            allow(Airbrake).to receive(:notify)
          end

          it "raises an exception" do
            expect { run_service }.to raise_exception(DefraRubyGovpay::GovpayApiError)
          end

          it "notifies Airbrake" do
            run_service
          rescue DefraRubyGovpay::GovpayApiError
            error_message = "Error sending request to govpay (get /payments/#{govpay_payment_id}/refunds/#{govpay_refund_id}, " \
                            "params: ), response body: : 500 Internal Server Error"
            expect(Airbrake).to have_received(:notify) do |error, details|
              expect(error).to be_a(DefraRubyGovpay::GovpayApiError)
              expect(error.message).to eq(error_message)
              expect(details[:message]).to eq("Error in Govpay refund details service")
              expect(details[:payment_id]).to eq(govpay_payment_id)
              expect(details[:refund_id]).to eq(govpay_refund_id)
            end
          end
        end
      end
    end
  end
end
