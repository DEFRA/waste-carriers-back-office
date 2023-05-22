# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe GovpayUpdateRefundStatusService do

    describe "#run" do
      let(:registration) { create(:registration, finance_details: build(:finance_details, :has_overpaid_order_and_payment_govpay)) }
      let(:payment) { registration.finance_details.payments.first }
      let(:refund_amount) { payment.amount - 100 }
      let(:refund_details_service) { instance_double(GovpayRefundDetailsService) }
      let(:refund) { build(:payment, :govpay_refund_pending, amount: refund_amount, refunded_payment_govpay_id: payment.govpay_id) }
      let(:refund_id) { refund.govpay_id }
      let(:govpay_response) do
        {
          "amount" => refund_amount,
          "created_date" => "2019-09-19T16:53:03.213Z",
          "refund_id" => refund_id,
          "status" => refund_status
        }
      end

      before do
        allow(GovpayRefundDetailsService).to receive(:new).and_return(refund_details_service)
        allow(refund_details_service).to receive(:run).and_return(govpay_response)
        registration.finance_details.payments << refund
      end

      subject(:run_service) { described_class.new.run(registration:, refund_id:) }

      context "when the refund status has not changed" do
        let(:refund_status) { "submitted" }

        it { expect(run_service).to be false }
        it { expect { run_service }.not_to change { refund.reload.govpay_payment_status } }
        it { expect { run_service }.not_to change { registration.reload.finance_details.balance } }
      end

      context "when the refund status has changed" do
        let(:refund_status) { "success" }

        it { expect(run_service).to be true }
        it { expect { run_service }.to change { refund.reload.govpay_payment_status }.to("success") }
        it { expect { run_service }.to change { registration.reload.finance_details.balance }.by(-refund_amount) }
      end
    end
  end
end
