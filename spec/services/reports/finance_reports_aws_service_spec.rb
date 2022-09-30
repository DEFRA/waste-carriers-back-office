# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe FinanceReportsAwsService do

    describe ".download_link" do
      let(:bucket) { double(:bucket) }
      let(:list_files_result) { double(:result) }
      let(:test_filename) { "test_file_2022-08-25_12-44-27.csv" }
      let(:s3_filepath) { "#{WasteCarriersBackOffice::Application.config.finance_reports_directory}/#{test_filename}" }
      let(:s3_url) { "https://some_bucket.amazonaws.com/#{s3_filepath}" }

      subject { described_class.new.download_link }

      before do
        allow(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        allow(bucket).to receive(:list_files).and_return(list_files_result)
        allow(list_files_result).to receive(:successful?).and_return(true)
        allow(list_files_result).to receive(:result).and_return(file_list)
      end

      context "when a single report file exists on S3" do
        let(:file_list) { [s3_filepath] }

        it "returns the download URL" do
          allow(bucket).to receive(:presigned_url).with(s3_filepath).and_return(s3_url)

          expect(subject).to eq s3_url
        end
      end

      context "when multiple report files exist on S3" do
        let(:filename_previous1) { "test_file_2022-08-24_23-59-59.csv" }
        let(:filename_previous2) { "test_file_2022-08-25_12-44-26.csv" }
        let(:s3_filepath_previous1) { "#{WasteCarriersBackOffice::Application.config.finance_reports_directory}/#{filename_previous1}" }
        let(:s3_filepath_previous2) { "#{WasteCarriersBackOffice::Application.config.finance_reports_directory}/#{filename_previous2}" }
        let(:file_list) { [s3_filepath_previous2, s3_filepath, s3_filepath_previous1] }

        it "returns a download URL for the latest file" do
          allow(bucket).to receive(:presigned_url).with(s3_filepath).and_return(s3_url)

          expect(subject).to eq s3_url
        end
      end

      context "when a report file does not exist on S3" do
        let(:file_list) { [] }

        it "returns nil" do
          expect(subject).to be_nil
        end
      end
    end
  end
end
