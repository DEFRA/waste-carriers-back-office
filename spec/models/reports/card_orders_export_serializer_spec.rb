# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe CardOrdersExportSerializer do

    let(:registration1) { create(:registration) }
    let(:end_time) { DateTime.now + 3.days }
    let(:start_time) { end_time - 1.week }
    let(:registration2) { create(:registration) }
    let(:registration3) { create(:registration) }
    let(:file_path) { Rails.root.join("tmp/card_orders_file.csv") }

    before do
      create(:order_item_log,
             type: "COPY_CARDS",
             registration_id: registration1.id,
             quantity: 2,
             activated_at: start_time + 1.second)
      create(:order_item_log,
             type: "COPY_CARDS",
             registration_id: registration2.id,
             quantity: 5,
             activated_at: end_time - 1.second)
    end

    subject(:serializer) { described_class.new(file_path, start_time, end_time) }

    describe "#to_csv" do
      let(:export_content) { File.read(file_path) }

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
        "Contact Address Line 1",
        "Contact Address Line 2",
        "Contact Address Line 3",
        "Contact Address Line 4",
        "Contact Address Line 5",
        "Contact Address Line 6",
        "Contact Town City",
        "Contact Postcode",
        "Contact Country"
      ].freeze

      it "includes the expected header" do
        serializer.to_csv

        expect(export_content).to include(expected_columns.map { |title| "\"#{title}\"" }.join(","))
      end

      context "with all registrations activated within the report window" do

        before { serializer.to_csv }

        it "includes one row per item ordered" do
          expect(export_content.scan(registration1.reg_identifier).size).to eq 2
          expect(export_content.scan(registration2.reg_identifier).size).to eq 5
        end

        # This is to ensure the export includes previously exported
        # items if run manually in addition to at the scheduled time.
        it "includes the same list of order items when run multiple times" do
          serializer.mark_exported
          described_class.new(file_path, start_time, end_time).to_csv

          expect(export_content.scan(registration1.reg_identifier).size).to eq 2
          expect(export_content.scan(registration2.reg_identifier).size).to eq 5
        end

        it "excludes non-copy-card order items" do
          non_card_order_item_log = WasteCarriersEngine::OrderItemLog.last
          non_card_order_item_log.update!(type: "NEW")
          subject.to_csv

          expect(export_content).not_to include(non_card_order_item_log.registration_id)
        end
      end

      context "with a registration activated after the report window" do
        let(:registration) { create(:registration) }

        before do
          create(:order_item_log,
                 type: "COPY_CARD",
                 registration_id: registration.id,
                 quantity: 2,
                 activated_at: end_time + 1.hour)
        end

        it "excludes the late order items" do
          expect(export_content).not_to include(registration.reg_identifier)
        end
      end

      context "with a registration activated before the report window" do
        let(:registration) { create(:registration) }

        before do
          create(:order_item_log,
                 type: "COPY_CARD",
                 registration_id: registration.id,
                 quantity: 2,
                 activated_at: start_time - 1.hour)
        end

        it "excludes order items for the earlier registration" do
          expect(export_content).not_to include(registration.reg_identifier)
        end
      end

      context "with an expired registration" do
        let(:registration) { create(:registration, :expired) }

        before do
          create(:order_item_log,
                 type: "COPY_CARD",
                 registration_id: registration.id,
                 quantity: 2,
                 activated_at: start_time + 1.second)
        end

        it "excludes order items for the expired registration" do
          expect(export_content).not_to include(registration.reg_identifier)
        end
      end

      context "with no eligible order item logs" do
        before { WasteCarriersEngine::OrderItemLog.delete_all }

        it "includes the expected header" do
          expect(export_content).to include(expected_columns.map { |title| "\"#{title}\"" }.join(","))
        end
      end

      context "with a nil quantity card order item" do
        before do
          create(:order_item_log,
                 type: "COPY_CARDS",
                 registration_id: registration3.id,
                 quantity: nil,
                 activated_at: start_time + 1.second)
        end

        it "excludes the order item without raising an error" do
          expect(export_content).not_to include(registration3.reg_identifier)
        end
      end
    end

    describe "#mark_exported" do
      serializer = nil

      context "with an existing serializer which has created a CSV export" do
        before do
          serializer = described_class.new(file_path, start_time, end_time)
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
