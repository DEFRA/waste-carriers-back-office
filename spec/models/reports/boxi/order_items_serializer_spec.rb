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

      describe "#add_entries_for" do
        let(:order) { double(:order) }

        it "creates an entry in the csv for each order_item in the order" do
          presenter = double(:presenter)
          order_item = double(:order_item)

          values = [
            0,
            0,
            "type",
            "amount",
            "description",
            "reference",
            "last_updated"
          ]

          allow(order).to receive(:order_items).and_return([order_item])

          expect(OrderItemPresenter).to receive(:new).with(order_item, nil).and_return(presenter)

          expect(presenter).to receive(:type).and_return("type")
          expect(presenter).to receive(:amount).and_return("amount")
          expect(presenter).to receive(:description).and_return("description")
          expect(presenter).to receive(:reference).and_return("reference")
          expect(presenter).to receive(:last_updated).and_return("last_updated")

          expect(CSV).to receive(:open).and_return(csv)
          expect(csv).to receive(:<<).with(headers)
          expect(csv).to receive(:<<).with(values)

          subject.add_entries_for(order, 0, 0)
        end

        it "sanitize data before inserting them in the csv" do
          presenter = double(:presenter, description: "string to sanitize\n").as_null_object

          order_item = double(:order_item)

          allow(order).to receive(:order_items).and_return([order_item])
          allow(OrderItemPresenter).to receive(:new).with(order_item, nil).and_return(presenter)

          allow(CSV).to receive(:open).and_return(csv)
          allow(csv).to receive(:<<).with(headers)

          expect(csv).to receive(:<<).with(array_including("string to sanitize"))

          subject.add_entries_for(order, 0, 0)
        end

        context "when there are no order items available" do
          it "does nothing and returns nil" do
            allow(order).to receive(:order_items).and_return(nil)

            expect(subject.add_entries_for(order, 0, 0)).to be_nil
          end
        end
      end
    end
  end
end
