# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe OrderItemsSerializer do
      let(:dir) { "/tmp/test" }
      let(:csv) { double(:csv) }
      let(:headers) do
        %w[
          RegistrationUID
          OrderUID
          ItemType
          ItemCharge
          Description
          Reference
          LastModifiedTimestamp
        ]
      end
      subject { described_class.new(dir) }

      before do
        expect(CSV).to receive(:open).and_return(csv)
        expect(csv).to receive(:<<).with(headers)
      end

      describe "#add_entries_for" do
        let(:registration) { double(:registration) }

        it "creates an entry in the csv for each order_item in the registration" do
          order = double(:order)
          order_item = double(:order_item)
          finance_details = double(:finance_details)

          values = [
            0,
            0,
            "type",
            "amount",
            "description",
            "reference",
            "last_updated"
          ]

          expect(registration).to receive(:finance_details).and_return(finance_details)
          expect(finance_details).to receive(:orders).and_return([order])
          expect(order).to receive(:order_items).and_return([order_item])

          expect(order_item).to receive(:type).and_return("type")
          expect(order_item).to receive(:amount).and_return("amount")
          expect(order_item).to receive(:description).and_return("description")
          expect(order_item).to receive(:reference).and_return("reference")
          expect(order_item).to receive(:last_updated).and_return("last_updated")

          expect(csv).to receive(:<<).with(values)

          subject.add_entries_for(registration, 0)
        end
      end
    end
  end
end
