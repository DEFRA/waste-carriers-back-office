# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe OrderItemLog, type: :model do
    describe "#initialize" do

      context "for a new registration" do
        let(:registration) { build(:registration, :has_orders_and_payments) }
        let(:order) { registration.finance_details.orders[0] }
        let(:registration_order_item) { order.order_items[0] }

        subject { described_class.create_from_order_item(registration_order_item) }

        it "persists the order item log" do
          expect { subject }.to change { OrderItemLog.count }.from(0).to(1)
        end

        it "saves the registration id" do
          expect(subject.registration_id).to eq registration.id
        end

        it "saves the registration activation date" do
          expect(subject.activated_at).to eq registration.metaData.dateActivated
        end

        it "saves the order id" do
          expect(subject.order_id).to eq order.id
        end

        it "is not exported by default" do
          expect(subject.exported).to be false
        end

        it "copies the OrderItem attributes" do
          expect(subject.order_item_id).to eq registration_order_item.id
          expect(subject.type).to eq registration_order_item.type
          expect(subject.quantity).to eq registration_order_item.quantity
        end
      end
    end

    describe ".create_from_registration" do
      let(:registration) { build(:registration, :has_orders_and_payments) }
      subject { described_class.create_from_registration(registration) }
      before do
        3.times { registration.finance_details.orders << build(:order, :has_copy_cards_item) }
      end

      context "for a new registration" do
        it "creates the correct number of order item logs" do
          expect { subject }.to change { OrderItemLog.count }
            .from(0)
            .to(order_item_count(registration))
        end
      end

      context "for a registration with previously logged order items" do
        let(:new_order) { build(:order, :has_copy_cards_item) }

        before do
          Timecop.freeze(1.month.ago) do
            described_class.create_from_registration(registration)
          end
        end

        it "adds only the new order item logs" do
          previous_count = order_item_count(registration)
          registration.finance_details.orders << new_order
          expect { subject }.to change { OrderItemLog.count }
            .from(previous_count)
            .to(order_item_count(registration))
        end

      end
    end

    def order_item_count(registration)
      registration.finance_details.orders.sum { |o| o.order_items.length }
    end
  end
end
