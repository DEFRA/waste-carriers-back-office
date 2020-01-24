# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe OrdersSerializer do
      let(:dir) { "/tmp/test" }
      let(:csv) { double(:csv) }
      let(:headers) do
        %w[
          RegistrationUID
          OrderUID
          OrderCode
          PaymentMethod
          TotalCharge
          Description
          MerchantID
          CreationTimestamp
          LastModifiedTimestamp
          LastModifiedBy
        ]
      end
      subject { described_class.new(dir) }

      describe "#add_entries_for" do
        let(:registration) { double(:registration) }

        it "creates an entry in the csv for each order in the registration" do
          order = double(:order)
          finance_details = double(:finance_details)
          presenter = double(:presenter)

          values = [
            0,
            0,
            "order_code",
            "payment_method",
            "total_amount",
            "description",
            "merchant_id",
            "date_created",
            "date_last_updated",
            "updated_by_user"
          ]

          allow(registration).to receive(:finance_details).and_return(finance_details)
          allow(finance_details).to receive(:orders).and_return([order])

          expect(OrderPresenter).to receive(:new).with(order, nil).and_return(presenter)

          expect(presenter).to receive(:order_code).and_return("order_code")
          expect(presenter).to receive(:payment_method).and_return("payment_method")
          expect(presenter).to receive(:total_amount).and_return("total_amount")
          expect(presenter).to receive(:description).and_return("description")
          expect(presenter).to receive(:merchant_id).and_return("merchant_id")
          expect(presenter).to receive(:date_created).and_return("date_created")
          expect(presenter).to receive(:date_last_updated).and_return("date_last_updated")
          expect(presenter).to receive(:updated_by_user).and_return("updated_by_user")

          expect(CSV).to receive(:open).and_return(csv)
          expect(csv).to receive(:<<).with(headers)
          expect(csv).to receive(:<<).with(values)

          subject.add_entries_for(registration, 0)
        end

        context "when there are no finance details available" do
          it "does nothing and returns nil" do
            expect(registration).to receive(:finance_details).and_return(nil)

            expect(subject.add_entries_for(registration, 0)).to be_nil
          end
        end

        context "when there are no orders available" do
          it "does nothing and returns nil" do
            finance_details = double(:finance_details, orders: nil)
            allow(registration).to receive(:finance_details).and_return(finance_details)

            expect(subject.add_entries_for(registration, 0)).to be_nil
          end
        end
      end
    end
  end
end
