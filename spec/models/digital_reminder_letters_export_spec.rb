# frozen_string_literal: true

require "rails_helper"

RSpec.describe DigitalReminderLettersExport, type: :model do
  subject(:digital_reminder_letters_export) { create(:digital_reminder_letters_export) }

  describe "Validations" do
    it "validates uniqueness of expires_on" do
      invalid_record = build(:digital_reminder_letters_export, expires_on: digital_reminder_letters_export.expires_on)

      expect(invalid_record).to_not be_valid
    end
  end

  describe "#export!" do
    it "kick off an export service job" do
      expect(DigitalReminderLettersExportService).to receive(:run).with(digital_reminder_letters_export)

      digital_reminder_letters_export.export!
    end
  end

  describe "#deleted!" do
    subject(:digital_reminder_letters_export) { create(:digital_reminder_letters_export, file_name: "foo.pdf") }

    let(:bucket) { double(:bucket) }

    it "deletes the file from AWS" do
      expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
      expect(bucket).to receive(:delete).with("foo.pdf")

      digital_reminder_letters_export.deleted!
    end
  end

  describe "#presigned_aws_url" do
    subject(:digital_reminder_letters_export) { build(:digital_reminder_letters_export, file_name: "foo.pdf") }

    let(:bucket) { double(:bucket) }
    let(:result) { double(:result) }

    it "ask the AWS bucket to generate a presigned url" do
      expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
      expect(bucket).to receive(:presigned_url).with("foo.pdf").and_return(result)

      expect(digital_reminder_letters_export.presigned_aws_url).to eq(result)
    end
  end

  describe "#printed?" do
    context "when both printed_on and printed_by are populated" do
      subject(:digital_reminder_letters_export) { build(:digital_reminder_letters_export, :printed) }

      it "is printed" do
        expect(digital_reminder_letters_export).to be_printed
      end
    end

    context "when printed_on is empty" do
      it "is not printed" do
        expect(digital_reminder_letters_export).to_not be_printed
      end
    end

    context "when printed_by is empty" do
      it "is not printed" do
        expect(digital_reminder_letters_export).to_not be_printed
      end
    end
  end
end
