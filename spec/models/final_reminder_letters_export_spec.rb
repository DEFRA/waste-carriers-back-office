# frozen_string_literal: true

require "rails_helper"

RSpec.describe FinalReminderLettersExport, type: :model do
  subject(:final_reminder_letters_export) { create(:final_reminder_letters_export) }

  describe "Validations" do
    it "validates uniqueness of expires_on" do
      invalid_record = build(:final_reminder_letters_export, expires_on: final_reminder_letters_export.expires_on)

      expect(invalid_record).to_not be_valid
    end
  end

  describe "#export!" do
    it "kick off an export service job" do
      expect(FinalReminderLettersExportService).to receive(:run).with(final_reminder_letters_export)

      final_reminder_letters_export.export!
    end
  end

  describe "#deleted!" do
    subject(:final_reminder_letters_export) { create(:final_reminder_letters_export, file_name: "foo.pdf") }

    let(:bucket) { double(:bucket) }

    it "deletes the file from AWS" do
      expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
      expect(bucket).to receive(:delete).with("foo.pdf")

      final_reminder_letters_export.deleted!
    end
  end

  describe "#presigned_aws_url" do
    subject(:final_reminder_letters_export) { build(:final_reminder_letters_export, file_name: "foo.pdf") }

    let(:bucket) { double(:bucket) }
    let(:result) { double(:result) }

    it "ask the AWS bucket to generate a presigned url" do
      expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
      expect(bucket).to receive(:presigned_url).with("foo.pdf").and_return(result)

      expect(final_reminder_letters_export.presigned_aws_url).to eq(result)
    end
  end

  describe "#printed?" do
    context "when both printed_on and printed_by are populated" do
      subject(:final_reminder_letters_export) { build(:final_reminder_letters_export, :printed) }

      it "is printed" do
        expect(final_reminder_letters_export).to be_printed
      end
    end

    context "when printed_on is empty" do
      it "is not printed" do
        expect(final_reminder_letters_export).to_not be_printed
      end
    end

    context "when printed_by is empty" do
      it "is not printed" do
        expect(final_reminder_letters_export).to_not be_printed
      end
    end
  end
end
