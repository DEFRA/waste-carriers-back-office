# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe FinanceReportsService do

    # Tests for the structure and content of the report are in the serializer_spec.
    describe ".run" do

      # Note that the test payments and orders are unrelated at the transaction level.
      # This is acceptable for unit test purposes as the service queries payments and orders/charges independently
      # and aggregates the results above the transaction level.
      include_context "with finance stats payment data"
      include_context "with finance stats order data"

      context "when the report is successfully generated and uploaded to S3" do
        let(:temp_dir) { Dir.mktmpdir }
        let(:bucket) { double(:bucket) }
        let(:upload_result) { double(:result) }
        let(:list_files_result) { double(:result) }
        let(:test_filename) { "test_file.csv" }
        let(:s3_test_filepath) { "FINANCE_REPORTS/#{test_filename}" }
        let(:s3_test_previous_filepath) { "FINANCE_REPORTS/a_file" }
        let(:file_path) { File.join(temp_dir, test_filename) }

        it "generates a report file, uploads it to AWS and deletes any previous files" do

          # populate test dir
          File.open(file_path, "w")

          allow_any_instance_of(described_class).to receive(:file_name).and_return(test_filename)
          allow(Dir).to receive(:mktmpdir).and_yield(temp_dir)
          expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket).at_least(:once)
          allow(bucket).to receive_messages(load: upload_result, list_files: list_files_result)
          expect(upload_result).to receive(:successful?).and_return(true).at_least(:once)
          expect(list_files_result).to receive(:successful?).and_return(true).at_least(:once)
          expect(list_files_result).to receive(:result).and_return([s3_test_previous_filepath, s3_test_filepath]).at_least(:once)
          expect(bucket).to receive(:delete).with(s3_test_previous_filepath)

          # expect no errors
          expect(Airbrake).not_to receive(:notify)
          expect(Rails.logger).not_to receive(:error)

          described_class.run
        end
      end

      context "when an error happens" do
        it "raises an error" do
          allow(FinanceStatsService).to receive(:new).and_raise("An error!")

          expect(Airbrake).to receive(:notify)
          expect(Rails.logger).to receive(:error)

          described_class.run
        end
      end
    end
  end
end
