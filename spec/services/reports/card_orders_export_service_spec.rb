# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe CardOrdersExportService do
    describe ".run" do
      let(:file_name) { "card_orders_#{Time.zone.today.strftime('%Y-%m-%d')}.csv" }
      let(:aws_file_pattern) { %r{https://.*\.s3\.eu-west-1\.amazonaws\.com/CARD_ORDERS/#{file_name}.*} }
      let(:end_time) { DateTime.now + 1.hour }
      let(:start_time) { end_time - 7.days }

      aws_stub = nil

      before do
        registrations = create_list(:registration, 2, :has_orders_and_payments)
        create(:order_item_log, type: "COPY_CARDS", registration_id: registrations[0].id, quantity: 3)
        create(:order_item_log, type: "COPY_CARDS", registration_id: registrations[1].id, quantity: 1)
        aws_stub = stub_request(:put, aws_file_pattern)
      end

      context "when the AWS request succeeds" do

        subject { described_class.new.run(start_time: start_time, end_time: end_time) }

        # rubocop:disable RSpec/NoExpectationExample
        it "executes a put request to AWS" do
          subject
          assert_requested aws_stub
        end
        # rubocop:enable RSpec/NoExpectationExample

        it "updates the status of the exported order_item_logs" do
          expect { subject }
            .to change { WasteCarriersEngine::OrderItemLog.where(exported: true).count }
            .from(0).to(2)
        end

        it "creates a CardOrdersExportLog with the correct attributes" do
          expect { subject }.to change(CardOrdersExportLog, :count).from(0).to(1)
          export_log = CardOrdersExportLog.first
          expect(export_log.start_time.to_i).to eq start_time.to_i
          expect(export_log.end_time.to_i).to eq end_time.to_i
          expect(export_log.exported_at).to be_within(1.second).of(DateTime.now)
          expect(export_log.export_filename).to eq file_name
        end

        it "does not report an error" do
          expect(Airbrake).not_to receive(:notify)

          described_class.new.run(start_time: start_time, end_time: end_time)
        end
      end

      context "when the request fails" do

        it "fails gracefully and reports the error" do
          stub_request(:put, aws_file_pattern).to_return(status: 403)

          # Expect an error to get notified
          expect(Airbrake).to receive(:notify).once

          described_class.new.run(start_time: start_time, end_time: end_time)
        end
      end
    end
  end
end
