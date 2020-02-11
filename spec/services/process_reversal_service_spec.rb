# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessReversalService do
  describe ".run" do
    let(:finance_details) { double(:finance_details) }
    let(:payment) { double(:payment, amount: 10, registration_reference: "Registration reference", order_key: "123") }
    let(:user) { double(:user, email: "user@example.com") }
    let(:reason) { "A reason" }

    it "generates a new payment and assigns it to the finance details" do
      reversal = double(:reversal)

      expect(finance_details).to receive_message_chain(:payments, :<<).with(reversal)
      expect(WasteCarriersEngine::Payment).to receive(:new).with(payment_type: WasteCarriersEngine::Payment::REVERSAL).and_return(reversal)

      expect(reversal).to receive(:order_key=).with("123_REVERSAL")
      expect(reversal).to receive(:amount=).with(-10)
      expect(reversal).to receive(:date_entered=).with(Date.today)
      expect(reversal).to receive(:date_received=).with(Date.today)
      expect(reversal).to receive(:registration_reference=).with("Registration reference")
      expect(reversal).to receive(:updated_by_user=).with("user@example.com")
      expect(reversal).to receive(:comment=).with("A reason")

      expect(finance_details).to receive(:update_balance)
      expect(finance_details).to receive(:save!)

      described_class.run({ finance_details: finance_details, payment: payment, user: user, reason: reason })
    end
  end
end
