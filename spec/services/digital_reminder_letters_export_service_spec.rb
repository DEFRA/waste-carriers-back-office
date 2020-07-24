# frozen_string_literal: true

require "rails_helper"

RSpec.describe DigitalReminderLettersExportService do
  describe ".run" do
    let(:bucket) { double(:bucket) }
    let(:result) { double(:result, successful?: true) }
    let(:digital_reminder_letters_export) { create(:digital_reminder_letters_export) }

    before do
      create_list(:registration, 3, expires_on: digital_reminder_letters_export.expires_on)
    end

    context "when there are digital registrations that are due for renewal reminders" do
      before do
        expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        expect(bucket).to receive(:load).and_return(result)
      end

      it "loads a file to a AWS bucket and records the content created" do
        expect(Airbrake).to_not receive(:notify)

        described_class.run(digital_reminder_letters_export)

        expect(digital_reminder_letters_export.number_of_letters).to eq(3)
        expect(digital_reminder_letters_export).to be_succeeded
      end

      context "when one registration is in an invalid state and a PDF cannot be generated for it" do
        it "raises an error on Airbrake but continues generation for the other letters" do
          registration = create(:registration, expires_on: digital_reminder_letters_export.expires_on)
          registration.contact_address.delete

          expect(Airbrake).to receive(:notify)

          described_class.run(digital_reminder_letters_export)

          expect(digital_reminder_letters_export.number_of_letters).to eq(4)
          expect(digital_reminder_letters_export).to be_succeeded
        end
      end
    end

    context "when an error happens" do
      it "notify Airbrake" do
        expect(DigitalReminderLettersBulkPdfService).to receive(:run).and_raise("An error")
        expect(Airbrake).to receive(:notify)

        described_class.run(digital_reminder_letters_export)
        expect(digital_reminder_letters_export).to be_failed
      end
    end
  end
end
