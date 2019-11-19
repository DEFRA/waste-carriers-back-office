# frozen_string_literal: true

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

  describe "#display_expiry_date" do
    let(:expires_on) { Time.now }
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
