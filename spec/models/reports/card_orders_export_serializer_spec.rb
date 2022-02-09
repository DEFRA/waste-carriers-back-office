# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe CardOrdersExportSerializer do

    let(:registration_1) { create(:registration, :has_orders_and_payments) }
    let(:registration_2) { create(:registration, :has_orders_and_payments) }
    let!(:order_item_log_1) { create(:order_item_log, type: "COPY_CARDS", registration_id: registration_1.id, quantity: 2) }
    let!(:order_item_log_2) { create(:order_item_log, type: "COPY_CARDS", registration_id: registration_2.id, quantity: 5) }

    let(:end_time) { DateTime.now + 3.days }
    let(:start_time) { end_time - 1.week }

    describe "#to_csv" do
      subject { described_class.new(start_time, end_time).to_csv }

      expected_columns = [
        "Registration Number",
        "Date of Issue",
        "Name of Registered Carrier",
        "Business Name",
        "Registered Address Line 1",
        "Registered Address Line 2",
        "Registered Address Line 3",
        "Registered Address Line 4",
        "Registered Address Line 5",
        "Registered Address Line 6",
        "Registered Town City",
        "Registered Postcode",
        "Registered Country",
        "Contact Phone Number",
        "Registration Date",
        "Expiry Date",
        "Registration Type",
        "Contact Address Line1",
        "Contact Address Line2",
        "Contact Address Line3",
        "Contact Address Line4",
        "Contact Address Line5",
        "Contact Address Line6",
        "Contact Town City",
        "Contact Postcode",
        "Contact Country"
      ].freeze

      it "includes the expected header" do
        expect(subject).to include(expected_columns.map { |title| "\"#{title}\"" }.join(","))
      end

      it "includes one row per item ordered for the previously un-exported items" do
        expect(subject.scan(registration_1.reg_identifier).size).to eq 2
        expect(subject.scan(registration_2.reg_identifier).size).to eq 5
      end

      it "excludes non-copy-card order items" do
        order_item_log_2.type = "NEW"
        order_item_log_2.save!
        expect(subject).not_to include(order_item_log_2.registration_id)
      end

      it "excludes previously exported items" do
        order_item_log_1.exported = true
        order_item_log_1.save!
        expect(subject).not_to include(order_item_log_1.registration_id)
      end

      context "with a registration activated outside the report window" do
        let(:late_registration) { create(:registration, :has_orders_and_payments) }
        let!(:late_order_item_log) { create(:order_item_log, type: "COPY_CARD", registration_id: late_registration.id, quantity: 2, activated_at: end_time + 1.hour) }

        it "excludes orders outside the report date range" do
          expect(subject).not_to include(late_registration.id)
        end
      end

      context "with no eligible order item logs" do
        before { WasteCarriersEngine::OrderItemLog.delete_all }

        it "includes the expected header" do
          expect(subject).to include(expected_columns.map { |title| "\"#{title}\"" }.join(","))
        end
      end
    end

    describe "#mark_exported" do
      serializer = nil

      context "with an existing serialiazer which has created a CSV export" do
        before do
          serializer = described_class.new(start_time, end_time)
          serializer.to_csv
        end

        it "updates the status of the exported order_item_logs" do
          expect { serializer.mark_exported }
            .to change { WasteCarriersEngine::OrderItemLog.where(exported: true).count }
            .from(0).to(2)
        end
      end
    end
  end
end
