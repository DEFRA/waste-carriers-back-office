# frozen_string_literal: true

require "rails_helper"

RSpec.describe FinalReminderLettersExportService do
  describe ".run" do
    let(:bucket) { double(:bucket) }
    let(:result) { double(:result, successful?: true) }
    let(:final_reminder_letters_export) { create(:final_reminder_letters_export) }

    before do
      create_list(:registration, 3, expires_on: final_reminder_letters_export.expires_on)
    end

    context "when there are new registrations from AD users" do
      before do
        expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        expect(bucket).to receive(:load).and_return(result)
      end

      it "load a file to a AWS bucket and record the content created" do
        expect(Airbrake).to_not receive(:notify)

        described_class.run(final_reminder_letters_export)

        expect(final_reminder_letters_export.number_of_letters).to eq(3)
        expect(final_reminder_letters_export).to be_succeded
      end

      context "when one registration is in an invalid state and a PDF cannot be generated for it" do
        pending "raises an error on Airbrake but continues generation for the other letters" do
          # TODO: Implement this when the template exists
          create(:registration, addresses: [], expires_on: final_reminder_letters_export.expires_on)

          expect(Airbrake).to receive(:notify)

          described_class.run(final_reminder_letters_export)

          expect(final_reminder_letters_export.number_of_letters).to eq(4)
          expect(final_reminder_letters_export).to be_succeded
        end
      end
    end

    context "when an error happens" do
      it "notify Airbrake" do
        expect(FinalReminderLettersBulkPdfService).to receive(:run).and_raise("An error")
        expect(Airbrake).to receive(:notify)

        described_class.run(final_reminder_letters_export)
        expect(final_reminder_letters_export).to be_failed
      end
    end
  end
end
