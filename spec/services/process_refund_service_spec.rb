# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessRefundService do
  describe ".run" do
    let(:finance_details) { double(:finance_details) }
    let(:payment) { double(:payment, order_key: "123", registration_reference: "registration_reference", amount: 1_500) }
    let(:user) { double(:user, email: "user@example.com") }
    let(:payments) { double(:payments) }
    let(:refund) { double(:refund) }

    before do
      allow(payment).to receive(:worldpay?).and_return(worldpay)
    end

    context "when the payment is a card payment" do
      let(:worldpay) { true }

      context "when a request to worldpay fails" do
        it "returns false and do not create a payment" do
          expect(Worldpay::RefundService).to receive(:run).with(payment: payment).and_return(false)

          expect(described_class.run(finance_details: finance_details, payment: payment, user: user)).to be_falsey
        end
      end

      context "when a request to worldpay is successfull" do
        it "sends a refund request to worldpay, generates a new refund payment and associate it with the right finance details" do
          description = double(:description)

          expect(finance_details).to receive(:payments).and_return(payments)
          expect(payments).to receive(:<<).with(refund)
          expect(finance_details).to receive(:update_balance)
          expect(finance_details).to receive(:save!)

          expect(WasteCarriersEngine::Payment).to receive(:new).with(payment_type: WasteCarriersEngine::Payment::REFUND).and_return(refund)
          expect(refund).to receive(:order_key=).with("123_REFUNDED")
          expect(refund).to receive(:date_entered=).with(Date.current)
          expect(refund).to receive(:date_received=).with(Date.current)
          expect(refund).to receive(:amount=).with(-1_500)
          expect(refund).to receive(:registration_reference=).with("registration_reference")
          expect(refund).to receive(:updated_by_user=).with("user@example.com")

          expect(I18n).to receive(:t).with("refunds.comment.card").and_return(description)
          expect(refund).to receive(:comment=).with(description)

          expect(Worldpay::RefundService).to receive(:run).with(payment: payment).and_return(true)

          expect(described_class.run(finance_details: finance_details, payment: payment, user: user)).to be_truthy
        end
      end

    end

    context "when the payment is a cash payment" do
      let(:worldpay) { false }

      before do
        expect(payment).to receive(:worldpay_missed?).and_return(false).twice
      end

      it "generates a new refund payment and associate it with the right finance details" do
        description = double(:description)

        expect(finance_details).to receive(:payments).and_return(payments)
        expect(payments).to receive(:<<).with(refund)
        expect(finance_details).to receive(:update_balance)
        expect(finance_details).to receive(:save!)

        expect(WasteCarriersEngine::Payment).to receive(:new).with(payment_type: WasteCarriersEngine::Payment::REFUND).and_return(refund)
        expect(refund).to receive(:order_key=).with("123_REFUNDED")
        expect(refund).to receive(:date_entered=).with(Date.current)
        expect(refund).to receive(:date_received=).with(Date.current)
        expect(refund).to receive(:amount=).with(-1_500)
        expect(refund).to receive(:registration_reference=).with("registration_reference")
        expect(refund).to receive(:updated_by_user=).with("user@example.com")

        expect(I18n).to receive(:t).with("refunds.comment.manual").and_return(description)

        expect(refund).to receive(:comment=).with(description)

        described_class.run(finance_details: finance_details, payment: payment, user: user)
      end
    end
  end
end
