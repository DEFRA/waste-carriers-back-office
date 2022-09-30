# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewingRegistrationPresenter do
  let(:renewing_registration) { double(:renewing_registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(renewing_registration, view_context) }

  describe "#display_current_workflow_state" do
    let(:workflow_state) { "a_workflow_state" }
    let(:renewing_registration) { double(:renewing_registration, workflow_state: workflow_state) }

    it "returns a displayable current workflow state string" do
      result = subject.display_current_workflow_state

      expect(result).to eq('The current form is "a_workflow_state"')
    end
  end

  describe "#rejected_header" do
    it "returns a translated message" do
      translated_header = double(:translated_header)
      key = ".renewing_registrations.show.status.headings.rejected"

      expect(I18n).to receive(:t).with(key).and_return(translated_header)

      expect(subject.rejected_header).to eq(translated_header)
    end
  end

  describe "#rejected_message" do
    it "returns a translated message" do
      translated_message = double(:translated_message)
      key = ".renewing_registrations.show.status.messages.rejected"

      expect(I18n).to receive(:t).with(key).and_return(translated_message)

      expect(subject.rejected_message).to eq(translated_message)
    end
  end

  describe "#in_progress?" do
    let(:renewing_registration) { double(:renewing_registration, renewal_application_submitted?: submitted) }

    context "when the application is not yet submitted" do
      let(:submitted) { false }

      it "returns true" do
        expect(subject).to be_in_progress
      end
    end

    context "when the application is submitted" do
      let(:submitted) { true }

      it "returns false" do
        expect(subject).to_not be_in_progress
      end
    end
  end

  describe "#display_expiry_date" do
    let(:expires_on) { Time.zone.now }
    let(:registration) { double(:registration, expires_on: expires_on) }
    let(:renewing_registration) { double(:renewing_registration, registration: registration) }

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
end
