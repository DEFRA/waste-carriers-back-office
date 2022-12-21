# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessChargeAdjustService do
  describe ".run" do
    let(:finance_details) { double(:finance_details) }
    let(:user) { double(:user) }
    let(:form) { double(:form, amount: 10, reference: "Reference", description: "Description") }

    it "generates a new order and assign it to the finance details" do
      item = double(:item)
      order = double(:order)

      allow(WasteCarriersEngine::OrderItem).to receive(:new_charge_adjust_item).and_return(item)
      allow(WasteCarriersEngine::Order).to receive(:new_order_for).with(user).and_return(order)

      expect(item).to receive(:amount=).with(10)
      expect(item).to receive(:reference=).with("Reference")
      expect(item).to receive(:description=).with("Description")

      expect(order).to receive(:order_items=).with([item])
      expect(order).to receive(:description=).with("Description")
      expect(order).to receive(:total_amount=).with(10)
      expect(order).to receive(:payment_method=)
      expect(order).to receive(:merchant_id=)

      allow(finance_details).to receive(:orders).and_return([])
      expect(finance_details.orders).to receive(:<<).with(order)
      expect(finance_details).to receive(:update_balance)
      expect(finance_details).to receive(:save!)

      described_class.run(finance_details: finance_details, user: user, form: form)
    end
  end
end
