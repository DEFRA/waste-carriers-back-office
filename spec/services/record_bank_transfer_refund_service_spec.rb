# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordBankTransferRefundService do
  describe ".run" do
    let(:finance_details) { double(:finance_details, balance: -100) }
    let(:payment) { double(:payment, amount: 100, registration_reference: "REG123", order_key: "ORDER456") }
    let(:user) { double(:user, email: "user@example.com") }
    let(:refund) { double(:refund) }

    before do
      allow(finance_details).to receive(:payments).and_return([])
      allow(finance_details).to receive(:update_balance)
      allow(finance_details).to receive(:save!)
    end

    context "when there is an overpayment" do
      before do
        allow(WasteCarriersEngine::Payment).to receive(:new).with(
          payment_type: WasteCarriersEngine::Payment::REFUND,
          order_key: "ORDER456_REFUNDED",
          amount: -100,
          date_entered: Date.current,
          date_received: Date.current,
          registration_reference: "REG123",
          updated_by_user: "user@example.com",
          comment: "Bank transfer payment refunded"
        ).and_return(refund)
      end

      it "generates a new refund payment and assigns it to the finance details" do
        expect(finance_details.payments).to receive(:<<).with(refund)
        expect(described_class.run(finance_details: finance_details, payment: payment, user: user)).to be true
      end
    end

    context "when there is no overpayment" do
      let(:finance_details) { double(:finance_details, balance: 100) }

      it "does not create a refund" do
        expect(finance_details.payments).not_to receive(:<<)
        expect(WasteCarriersEngine::Payment).not_to receive(:new)
        expect(described_class.run(finance_details: finance_details, payment: payment, user: user)).to be true
      end
    end

    context "when an error occurs" do
      before do
        allow(finance_details).to receive(:balance).and_return(-100)
        allow(finance_details).to receive(:save!).and_raise(StandardError)
        allow(Rails.logger).to receive(:error)
        allow(Airbrake).to receive(:notify)
      end

      it "logs the error and returns false" do
        expect(described_class.run(finance_details: finance_details, payment: payment, user: user)).to be false
        expect(Rails.logger).to have_received(:error).with(/StandardError error processing refund for payment ORDER456/)
        expect(Airbrake).to have_received(:notify)
      end
    end
  end
end
