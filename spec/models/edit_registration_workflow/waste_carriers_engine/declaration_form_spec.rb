# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteCarriersEngine::DeclarationForm do
  subject(:declaration_form) { build(:edit_registration, workflow_state: "declaration_form") }

  describe "#workflow_state" do
    context "with :declaration_form state transitions" do
      context "with :next transition" do
        include_examples "has next transition", next_state: "edit_complete_form"

        context "when the registration has changed business type" do
          before { declaration_form.registration_type = "carrier_dealer" }

          include_examples "has next transition", next_state: "edit_payment_summary_form"
        end
      end
    end
  end
end
