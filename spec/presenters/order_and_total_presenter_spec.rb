# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe OrderAndTotalPresenter do
    subject(:presenter) { described_class.new(form, view) }

    let(:form) { double(:form, transient_registration: transient_registration) }
    let(:transient_registration) do
      double(:transient_registration,
             finance_details: finance_details,
             temp_cards: temp_cards)
    end
    let(:temp_cards) { 2 }

    let(:finance_details) { double(:finance_details, balance: balance, orders: orders) }
    let(:balance) { 0 }
    let(:orders) { [order] }
    let(:order) { double(:order, order_items: order_items) }

    let(:order_items) { [] }
    let(:renewal_order_item) { double(:order_item, type: OrderItem::TYPES[:renew], amount: 10_500) }
    let(:edit_order_item) { double(:order_item, type: OrderItem::TYPES[:edit], amount: 4_000) }
    let(:copy_cards_order_item) { double(:order_item, type: OrderItem::TYPES[:copy_cards], amount: 1_000) }
    let(:charge_adjust_order_item) { double(:order_item, type: OrderItem::TYPES[:charge_adjust], amount: 500) }

    describe "#order_items" do
      let(:order_items) { [edit_order_item, copy_cards_order_item, charge_adjust_order_item] }

      it "returns a correctly-formatted list with descriptions and values" do
        expected_list = [
          {
            description: "Charge for changing registration type",
            amount: 4_000
          },
          {
            description: "2 registration cards total cost",
            amount: 1_000
          },
          {
            description: "Charge adjust",
            amount: 500
          }
        ]
        expect(presenter.order_items).to eq(expected_list)
      end

      context "when the transient registration is a renewal" do
        let(:order_items) { [renewal_order_item, edit_order_item, copy_cards_order_item, charge_adjust_order_item] }

        before { allow(transient_registration).to receive(:is_a?).with(RenewingRegistration).and_return(true) }

        it "returns a correctly-formatted list with the renewal description and values" do
          expected_list = [
            {
              description: "Renewal of registration",
              amount: 10_500
            },
            {
              description: "Additional charge for changing registration type",
              amount: 4_000
            },
            {
              description: "2 registration cards total cost",
              amount: 1_000
            },
            {
              description: "Charge adjust",
              amount: 500
            }
          ]
          expect(presenter.order_items).to eq(expected_list)
        end
      end
    end

    describe "#total_cost" do
      it "returns the balance" do
        expect(presenter.total_cost).to eq(balance)
      end
    end
  end
end
