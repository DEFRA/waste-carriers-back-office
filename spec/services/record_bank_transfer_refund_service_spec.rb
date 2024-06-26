# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordBankTransferRefundService do
  describe ".run" do
    let(:finance_details) { double(:finance_details) }
    let(:payment) { double(:payment, amount: 100, registration_reference: "REG123", order_key: "ORDER456") }
    let(:user) { double(:user, email: "user@example.com") }

    it "generates a new refund payment and assigns it to the finance details" do
      refund = double(:refund)
      allow(finance_details).to receive(:payments).and_return([])
      expect(finance_details.payments).to receive(:<<).with(refund)

      allow(WasteCarriersEngine::Payment).to receive(:new).with(payment_type: WasteCarriersEngine::Payment::REFUND).and_return(refund)

      expect(refund).to receive(:order_key=).with("ORDER456_REFUNDED")
      expect(refund).to receive(:amount=).with(-100)
      expect(refund).to receive(:date_entered=).with(Date.current)
      expect(refund).to receive(:date_received=).with(Date.current)
      expect(refund).to receive(:registration_reference=).with("REG123")
      expect(refund).to receive(:updated_by_user=).with("user@example.com")
      expect(refund).to receive(:comment=).with("Bank transfer payment refunded")

      expect(finance_details).to receive(:update_balance)
      expect(finance_details).to receive(:save!)

      described_class.run(finance_details: finance_details, payment: payment, user: user)
    end
  end
end
