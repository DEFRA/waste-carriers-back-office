# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe CardOrdersExportSerializer do

    let(:registration_1) { create(:registration) }
    let(:registration_2) { create(:registration) }

    let!(:order_item_log_1) do
      create(:order_item_log,
             type: "COPY_CARDS",
             registration_id: registration_1.id,
             quantity: 2,
             activated_at: start_time + 1.second)
    end
    let!(:order_item_log_2) do
      create(:order_item_log,
             type: "COPY_CARDS",
             registration_id: registration_2.id,
             quantity: 5,
             activated_at: end_time - 1.second)
    end

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
        "Contact Town City",
        "Contact Postcode",
        "Contact Country"
      ].freeze

      it "includes the expected header" do
        expect(subject).to include(expected_columns.map { |title| "\"#{title}\"" }.join(","))
      end

      context "with all registrations activated within the report window" do

        it "includes one row per item ordered" do
          expect(subject.scan(registration_1.reg_identifier).size).to eq 2
          expect(subject.scan(registration_2.reg_identifier).size).to eq 5
        end

        # This is to ensure the export includes previously exported
        # items if run manually in addition to at the scheduled time.
        it "includes the same list of order items when run multiple times" do
          serializer = described_class.new(start_time, end_time)
          serializer.to_csv
          serializer.mark_exported
          export2 = described_class.new(start_time, end_time).to_csv
          expect(export2.scan(registration_1.reg_identifier).size).to eq 2
          expect(export2.scan(registration_2.reg_identifier).size).to eq 5
        end

        it "excludes non-copy-card order items" do
          order_item_log_2.type = "NEW"
          order_item_log_2.save!
          expect(subject).not_to include(order_item_log_2.registration_id)
        end
      end

      context "with a registration activated after the report window" do
        let(:registration) { create(:registration) }
        let!(:order_item_log) do
          create(:order_item_log,
                 type: "COPY_CARD",
                 registration_id: registration.id,
                 quantity: 2,
                 activated_at: end_time + 1.hour)
        end

        it "excludes the late order items" do
          expect(subject).not_to include(registration.reg_identifier)
        end
      end

      context "with a registration activated before the report window" do
        let(:registration) { create(:registration) }
        let!(:order_item_log) do
          create(:order_item_log,
                 type: "COPY_CARD",
                 registration_id: registration.id,
                 quantity: 2,
                 activated_at: start_time - 1.hour)
        end

        it "excludes order items for the earlier registration" do
          expect(subject).not_to include(registration.reg_identifier)
        end
      end

      context "with an expired registration" do
        let(:registration) { create(:registration, :expired) }
        let!(:order_item_log) do
          create(:order_item_log,
                 type: "COPY_CARD",
                 registration_id: registration.id,
                 quantity: 2,
                 activated_at: start_time + 1.second)
        end

        it "excludes order items for the expired registration" do
          expect(subject).not_to include(registration.reg_identifier)
        end
      end

      context "with no eligible order item logs" do
        before { WasteCarriersEngine::OrderItemLog.delete_all }

        it "includes the expected header" do
          expect(subject).to include(expected_columns.map { |title| "\"#{title}\"" }.join(","))
        end
      end

      context "with a nil quantity card order item" do
        let!(:order_item_log_1) do
          create(:order_item_log,
                 type: "COPY_CARDS",
                 registration_id: registration_1.id,
                 quantity: nil,
                 activated_at: start_time + 1.second)
        end

        it "excludes the order item without raising an error" do
          expect(subject).not_to include(registration_1.reg_identifier)
        end
      end
    end

    describe "#mark_exported" do
      serializer = nil

      context "with an existing serializer which has created a CSV export" do
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
