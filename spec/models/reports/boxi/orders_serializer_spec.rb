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

      before do
        expect(CSV).to receive(:open).and_return(csv)
        expect(csv).to receive(:<<).with(headers)
      end

      describe "#add_entries_for" do
        let(:registration) { double(:registration) }

        it "creates an entry in the csv for each order_item in the registration" do
          order = double(:order)
          finance_details = double(:finance_details)

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

          expect(registration).to receive(:finance_details).and_return(finance_details)
          expect(finance_details).to receive(:orders).and_return([order])

          expect(order).to receive(:order_code).and_return("order_code")
          expect(order).to receive(:payment_method).and_return("payment_method")
          expect(order).to receive(:total_amount).and_return("total_amount")
          expect(order).to receive(:description).and_return("description")
          expect(order).to receive(:merchant_id).and_return("merchant_id")
          expect(order).to receive(:date_created).and_return("date_created")
          expect(order).to receive(:date_last_updated).and_return("date_last_updated")
          expect(order).to receive(:updated_by_user).and_return("updated_by_user")


          expect(csv).to receive(:<<).with(values)

          subject.add_entries_for(registration, 0)
        end
      end
    end
  end
end
