# frozen_string_literal: true

require "rails_helper"

RSpec.describe FinalReminderLettersBulkPdfService do
  describe ".run" do
    let(:registrations) { create_list(:registration, 2, :expires_soon) }
    let(:result) { double(:result) }

    it "returns a PDF string" do
      expect(Airbrake).to_not receive(:notify)

      expect(described_class.run(registrations)).to start_with("%PDF")
    end

    context "when an error happens" do
      it "notify Airbrake" do
        expect_any_instance_of(ApplicationController).to receive(:render_to_string).and_raise("An error")
        expect(Airbrake).to receive(:notify)

        expect { described_class.run(registrations) }.to raise_error("An error")
      end
    end

    context "when there are no registrations" do
      it "returns a result" do
        expect(described_class.run([])).to be_nil
      end
    end
  end
end
