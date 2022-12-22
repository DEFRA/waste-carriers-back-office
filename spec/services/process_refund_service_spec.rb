# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessRefundService do
  describe ".run" do
    subject(:refund_service) { described_class }

    let(:orders) { double(:orders) }
    let(:order) { double(:order, merchant_id: "merchant_code") }
    let(:finance_details) { double(:finance_details, balance: -500, orders: orders) }
    let(:payment) { double(:payment, order_key: "123", registration_reference: "registration_reference", amount: 1_500, payment_type: "payment_type") }
    let(:user) { double(:user, email: "user@example.com") }
    let(:payments) { double(:payments) }
    let(:refund) { double(:refund) }
    let(:worldpay) { true }
    let(:govpay) { false }
    let(:govpay_host) { "https://publicapi.payments.service.gov.uk" }

    before do
      allow(payment).to receive(:worldpay?).and_return(worldpay)
      allow(payment).to receive(:govpay?).and_return(govpay)
      allow(orders).to receive(:find_by).and_return(order)
    end

    context "when the registration balance is not negative" do
      let(:finance_details) { double(:finance_details, balance: 500) }

      it "returns false and does not create a payment" do
        expect(refund_service.run(finance_details: finance_details, payment: payment, user: user)).to be_falsey
      end
    end

    context "when the payment is a card payment" do
      context "when using govpay" do
        let(:govpay) { true }
        let(:worldpay) { false }

        context "when the request fails" do
          it "returns false and does not create a payment" do
            expect(WasteCarriersEngine::GovpayRefundService).to receive(:run).with(payment: payment, amount: 500, merchant_code: "merchant_code").and_return(false)

            expect(refund_service.run(finance_details: finance_details, payment: payment, user: user, refunder: WasteCarriersEngine::GovpayRefundService)).to be_falsey
          end
        end

        context "when the Govpay refind service returns an error" do
          let(:govpay_refund_service) { instance_double(WasteCarriersEngine::GovpayRefundService) }

          before do
            allow(payment).to receive(:govpay_id)
            allow(WasteCarriersEngine::GovpayRefundService).to receive(:new).and_return(govpay_refund_service)
            allow(govpay_refund_service).to receive(:run).and_raise(WasteCarriersEngine::GovpayApiError)
            allow(Airbrake).to receive(:notify)
          end

          it "notifies Airbrake" do
            refund_service.run(finance_details: finance_details, payment: payment, user: user, refunder: WasteCarriersEngine::GovpayRefundService)
          rescue WasteCarriersEngine::GovpayApiError
            expect(Airbrake).to have_received(:notify) # rubocop:disable RSpec/MessageSpies
          end
        end

        context "when the request succeeds" do
          it "returns true and creates a (refund) payment" do
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

            expect(I18n).to receive(:t).with("refunds.comments.card", type: "Payment Type").and_return(description)
            expect(refund).to receive(:comment=).with(description)

            expect(WasteCarriersEngine::GovpayRefundService).to receive(:run).with(payment: payment, amount: 500, merchant_code: "merchant_code").and_return(true)

            expect(refund_service.run(finance_details: finance_details, payment: payment, user: user, refunder: WasteCarriersEngine::GovpayRefundService)).to be_truthy
          end
        end
      end

      context "when using worldpay" do
        let(:worldpay) { true }

        context "when a request to worldpay fails" do
          it "returns false and does not create a payment" do
            expect(Worldpay::RefundService).to receive(:run).with(payment: payment, amount: 500, merchant_code: "merchant_code").and_return(false)

            expect(refund_service.run(finance_details: finance_details, payment: payment, user: user)).to be_falsey
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

            expect(I18n).to receive(:t).with("refunds.comments.card", type: "Payment Type").and_return(description)
            expect(refund).to receive(:comment=).with(description)

            expect(Worldpay::RefundService).to receive(:run).with(payment: payment, amount: 500, merchant_code: "merchant_code").and_return(true)

            expect(refund_service.run(finance_details: finance_details, payment: payment, user: user)).to be_truthy
          end
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

        refund_service.run(finance_details: finance_details, payment: payment, user: user)
      end
    end
  end
end
