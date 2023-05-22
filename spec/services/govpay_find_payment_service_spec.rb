# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe GovpayFindPaymentService do

    describe "#run" do

      subject(:run_service) { described_class.run(payment_id:) }

      context "with an invalid payment id" do
        let(:payment_id) { "bad_id" }

        it "raises an exception" do
          expect { run_service }.to raise_exception(ArgumentError)
        end
      end

      context "with a valid payment id" do
        let(:registration) { create(:registration, finance_details: build(:finance_details, :has_overpaid_order_and_payment_govpay)) }
        let(:payment) { registration.finance_details.payments.first }
        let(:payment_id) { payment.govpay_id }

        it "returns the payment" do
          expect(run_service).to eq payment
        end
      end
    end
  end
end
