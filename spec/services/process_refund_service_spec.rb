# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessRefundService do
  describe ".run" do
    let(:orders) { double(:orders) }
    let(:order) { double(:order, merchant_id: "merchant_code") }
    let(:finance_details) { double(:finance_details, balance: -500, orders: orders) }
    let(:payment) { double(:payment, order_key: "123", registration_reference: "registration_reference", amount: 1_500) }
    let(:user) { double(:user, email: "user@example.com") }
    let(:payments) { double(:payments) }
    let(:refund) { double(:refund) }
    let(:worldpay) { true }

    before do
      allow(payment).to receive(:worldpay?).and_return(worldpay)
      allow(orders).to receive(:find_by).and_return(order)
    end

    context "when the registration balance is not negative" do
      let(:finance_details) { double(:finance_details, balance: 500) }

      it "returns false and does not create a payment" do
        expect(described_class.run(finance_details: finance_details, payment: payment, user: user)).to be_falsey
      end
    end

    context "when the payment is a card payment" do
      let(:worldpay) { true }

      context "when a request to worldpay fails" do
        it "returns false and does not create a payment" do
          expect(Worldpay::RefundService).to receive(:run).with(payment: payment, amount: 500, merchant_code: "merchant_code").and_return(false)

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
          expect(refund).to receive(:amount=).with(-500)
          expect(refund).to receive(:registration_reference=).with("registration_reference")
          expect(refund).to receive(:updated_by_user=).with("user@example.com")
          expect(refund).to receive(:world_pay_payment_status=).with("AUTHORISED")

          expect(I18n).to receive(:t).with("refunds.comments.card").and_return(description)
          expect(refund).to receive(:comment=).with(description)

          expect(Worldpay::RefundService).to receive(:run).with(payment: payment, amount: 500, merchant_code: "merchant_code").and_return(true)

          expect(described_class.run(finance_details: finance_details, payment: payment, user: user)).to be_truthy
        end
      end

    end

    context "when the payment is a cash payment" do
      let(:worldpay) { false }

      before do
        allow(payment).to receive(:worldpay_missed?).and_return(false)
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
        expect(refund).to receive(:amount=).with(-500)
        expect(refund).to receive(:registration_reference=).with("registration_reference")
        expect(refund).to receive(:updated_by_user=).with("user@example.com")

        expect(I18n).to receive(:t).with("refunds.comments.manual").and_return(description)

        expect(refund).to receive(:comment=).with(description)

        described_class.run(finance_details: finance_details, payment: payment, user: user)
      end
    end
  end
end
