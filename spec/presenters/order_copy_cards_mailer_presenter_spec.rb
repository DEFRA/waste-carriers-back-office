# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderCopyCardsMailerPresenter do
  subject(:presenter) { described_class.new(registration, order) }

  let(:registration) { instance_double(WasteCarriersEngine::Registration) }
  let(:order) { instance_double(WasteCarriersEngine::Order) }

  describe "#contact_name" do
    it "returns a string with first and last name" do
      allow(registration).to receive_messages(first_name: "Bob", last_name: "Proctor")

      expect(presenter.contact_name).to eq("Bob Proctor")
    end
  end

  describe "#total_cards" do
    it "returns the order item's quantity" do
      order_item = instance_double(WasteCarriersEngine::OrderItem)
      result = instance_double(Integer)

      allow(order).to receive(:order_items).and_return([order_item])
      allow(order_item).to receive(:quantity).and_return(result)

      expect(presenter.total_cards).to eq(result)
    end
  end

  describe "#order_description" do
    it "returns the order's description" do
      order_item = instance_double(WasteCarriersEngine::OrderItem)
      result = instance_double(String)

      allow(order).to receive(:order_items).and_return([order_item])
      allow(order_item).to receive(:description).and_return(result)

      expect(presenter.order_description).to eq(result)
    end
  end

  describe "#ordered_on_formatted_string" do
    it "returns the date the order was created as a string eg '31 October 2010'" do
      allow(order).to receive(:date_created).and_return(Time.zone.parse("2010-10-31").to_datetime)

      expect(presenter.ordered_on_formatted_string).to eq("31 October 2010")
    end
  end
end
