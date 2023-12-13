# frozen_string_literal: true

require "rails_helper"

RSpec.describe BuildOrderCopyCardsFinanceDetailsService do
  describe ".run" do
    let(:user) { instance_double(User, email: "user@example.com") }
    let(:transient_registration) { instance_double(OrderCopyCardsRegistration) }
    let(:order) { instance_double(WasteCarriersEngine::Order) }

    before do
      finance_details = instance_double(WasteCarriersEngine::FinanceDetails)
      order_item = instance_double(WasteCarriersEngine::OrderItem)
      orders = [instance_double(WasteCarriersEngine::Order)]

      allow(WasteCarriersEngine::FinanceDetails).to receive(:new).and_return(finance_details)
      allow(finance_details).to receive(:transient_registration=).with(transient_registration)
      allow(WasteCarriersEngine::Order).to receive(:new_order_for).with("user@example.com").and_return(order)
      allow(WasteCarriersEngine::OrderItem).to receive(:new_copy_cards_item).with(2).and_return(order_item)
      allow(order).to receive(:set_description)
      allow(order).to receive(:[]=).with(:order_items, [order_item])
      allow(order_item).to receive(:[]).with(:amount).and_return(10)
      allow(order).to receive(:[]=).with(:total_amount, 10)
      allow(finance_details).to receive(:[]).with(:orders).and_return(orders).twice
      allow(orders).to receive(:<<).with(order)
      allow(finance_details).to receive(:update_balance)
      allow(finance_details).to receive(:save!)
    end

    context "when the payment method is bank transfer" do
      let(:payment_method) { :bank_transfer }

      it "updates the transient_registration's finance details with a new order for the given copy cards" do
        allow(order).to receive(:add_bank_transfer_attributes)

        described_class.run(cards_count: 2, user: user, transient_registration: transient_registration, payment_method: payment_method)

        expect(order).to have_received(:add_bank_transfer_attributes)
      end
    end

    context "when the payment method is govpay" do
      let(:payment_method) { :govpay }

      it "updates the transient_registration's finance details with a new order for the given copy cards" do
        allow(order).to receive(:add_govpay_attributes)

        described_class.run(cards_count: 2, user: user, transient_registration: transient_registration, payment_method: payment_method)

        expect(order).to have_received(:add_govpay_attributes)
      end
    end
  end
end
