# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteCarriersEngine::CompanyNameForm do
  subject { build(:edit_registration, workflow_state: "company_name_form") }

  describe "#workflow_state" do
    context "with :company_name_form state transitions" do
      context "with :next transition" do
        it_behaves_like "has next transition", next_state: "edit_form"
      end
    end
  end
end
