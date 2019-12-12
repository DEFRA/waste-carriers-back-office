# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationPresenter do
  let(:registration) { double(:registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#display_expiry_date" do
    let(:expires_on) { Time.now }
    let(:registration) { double(:registration, expires_on: expires_on) }

    it "returns a date object" do
      expect(subject.display_expiry_date).to be_a(Date)
    end

    context "when there is no expire date" do
      let(:expires_on) { nil }

      it "returns nil" do
        expect(subject.display_expiry_date).to be_nil
      end
    end
  end

  describe "#rejected_header" do
    it "returns a translated message" do
      translated_header = double(:translated_header)
      key = ".registrations.show.status.headings.rejected"

      expect(I18n).to receive(:t).with(key).and_return(translated_header)

      expect(subject.rejected_header).to eq(translated_header)
    end
  end

  describe "#rejected_message" do
    it "returns a translated message" do
      translated_message = double(:translated_message)
      key = ".registrations.show.status.messages.rejected"

      expect(I18n).to receive(:t).with(key).and_return(translated_message)

      expect(subject.rejected_message).to eq(translated_message)
    end
  end

  describe "#display_registration_status" do
    let(:metadata) { double(:metadata, status: "PENDING") }
    let(:registration) { double(:registration, metaData: metadata) }

    it "returns a titleized status" do
      expect(subject.display_registration_status).to eq("Pending")
    end
  end
end
