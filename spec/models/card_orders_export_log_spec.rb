# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardOrdersExportLog do
  subject { described_class.new(start_time, end_time, export_filename, exported_at) }

  let(:export_filename) { Faker::File.file_name }
  let(:start_time) { Faker::Date.in_date_period.midnight }
  let(:end_time) { start_time + 1.week }
  let(:exported_at) { end_time + 30.hours }

  describe "#initialize" do
    it "records the time of the export" do
      expect(subject.exported_at).to eq exported_at
    end

    it "records the export filename" do
      expect(subject.export_filename).to eq export_filename
    end

    it "records the reporting window start and end time" do
      expect(subject.start_time).to eq start_time
      expect(subject.end_time).to eq end_time
    end
  end

  describe "#download_link" do
    it "includes the designated AWS S3 bucket name" do
      expect(subject.download_link).to include WasteCarriersBackOffice::Application.config.weekly_exports_bucket_name
    end

    it "includes the export file name" do
      expect(subject.download_link).to include subject.export_filename
    end
  end
end
