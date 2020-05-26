# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewRegistrationPresenter do
  let(:new_registration) { double(:new_registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(new_registration, view_context) }

  describe "#display_current_workflow_state" do
    let(:workflow_state) { "a_workflow_state" }
    let(:new_registration) { double(:new_registration, workflow_state: workflow_state) }

    it "returns a displayable current workflow state string" do
      result = subject.display_current_workflow_state

      expect(result).to eq('The current form is "a_workflow_state"')
    end
  end
end
