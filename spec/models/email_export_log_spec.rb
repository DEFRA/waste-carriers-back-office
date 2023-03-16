# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmailExportLog do
  subject(:export_log) { described_class.new(export_filename, exported_at) }

  let(:export_filename) { Faker::File.file_name }
  let(:exported_at) { 1.day.ago }

  describe "#initialize" do
    it "records the time of the export" do
      expect(export_log.exported_at).to eq exported_at
    end

    it "records the export filename" do
      expect(export_log.export_filename).to eq export_filename
    end
  end

  describe "#download_link" do
    it "includes the designated AWS S3 bucket name" do
      expect(export_log.download_link).to include WasteCarriersBackOffice::Application.config.email_exports_bucket_name
    end

    it "includes the export file name" do
      expect(export_log.download_link).to include export_log.export_filename
    end
  end
end
