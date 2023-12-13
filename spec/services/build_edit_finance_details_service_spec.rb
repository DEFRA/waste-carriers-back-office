# frozen_string_literal: true

require "rails_helper"

RSpec.describe BuildEditFinanceDetailsService do
  describe ".run" do
    let(:user) { double(:user) }
    let(:transient_registration) { double(:transient_registration) }
    let(:order) { double(:order) }

    before do
      finance_details = double(:finance_details)
      order_item = double(:order_item)
      orders = double(:orders)

      allow(WasteCarriersEngine::FinanceDetails).to receive(:new).and_return(finance_details)
      allow(finance_details).to receive(:transient_registration=).with(transient_registration)
      allow(WasteCarriersEngine::Order).to receive(:new_order_for).with(user).and_return(order)
      allow(transient_registration).to receive(:registration_type_changed?).and_return(true)
      allow(WasteCarriersEngine::OrderItem).to receive(:new_type_change_item).and_return(order_item)
      allow(order).to receive(:set_description)
      allow(order).to receive(:[]=).with(:order_items, [order_item])
      allow(order_item).to receive(:[]).with(:amount).and_return(40)
      allow(order).to receive(:[]=).with(:total_amount, 40)
      allow(finance_details).to receive(:[]).with(:orders).and_return(orders).twice
      allow(orders).to receive(:<<).with(order)
      allow(finance_details).to receive(:update_balance)
      allow(finance_details).to receive(:save!)
    end

    context "when the payment method is bank transfer" do
      let(:payment_method) { :bank_transfer }

      it "updates the transient_registration's finance details with a new order for the change fee" do
        allow(order).to receive(:add_bank_transfer_attributes)

        described_class.run(user: user, transient_registration: transient_registration, payment_method: payment_method)

        expect(order).to have_received(:add_bank_transfer_attributes)
      end
    end

    context "when the payment method is govpay" do
      let(:payment_method) { :govpay }

      it "updates the transient_registration's finance details with a new order for the change fee" do
        allow(order).to receive(:add_govpay_attributes)

        described_class.run(user: user, transient_registration: transient_registration, payment_method: payment_method)

        expect(order).to have_received(:add_govpay_attributes)
      end
    end
  end
end
