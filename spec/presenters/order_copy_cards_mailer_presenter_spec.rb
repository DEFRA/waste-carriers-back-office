# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderCopyCardsMailerPresenter do
  subject(:presenter) { described_class.new(registration, order) }
  let(:registration) { double(:registration) }
  let(:order) { double(:order) }

  describe "#contact_name" do
    it "returns a string with first and last name" do
      allow(registration).to receive(:first_name).and_return("Bob")
      allow(registration).to receive(:last_name).and_return("Proctor")

      expect(presenter.contact_name).to eq("Bob Proctor")
    end
  end

  describe "#total_cards" do
    it "returns the order item's quantity" do
      order_item = double(:order_item)
      result = double(:result)

      allow(order).to receive(:order_items).and_return([order_item])
      allow(order_item).to receive(:quantity).and_return(result)

      expect(presenter.total_cards).to eq(result)
    end
  end

  describe "#order_description" do
    it "returns the order's description" do
      order_item = double(:order_item)
      result = double(:result)

      allow(order).to receive(:order_items).and_return([order_item])
      allow(order_item).to receive(:description).and_return(result)

      expect(presenter.order_description).to eq(result)
    end
  end

  describe "#ordered_on_formatted_string" do
    it "returns the date the order was created as a string eg '31 October 2010'" do
      allow(order).to receive(:date_created).and_return(Time.parse("2010-10-31").to_datetime)

      expect(presenter.ordered_on_formatted_string).to eq("31 October 2010")
    end
  end
end
