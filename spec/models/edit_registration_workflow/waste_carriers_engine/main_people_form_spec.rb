# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteCarriersEngine::MainPeopleForm do
  subject { build(:edit_registration, workflow_state: "main_people_form") }

  describe "#workflow_state" do
    context "with :main_people_form state transitions" do
      context "with :next transition" do
        include_examples "has next transition", next_state: "edit_form"
      end
    end
  end
end
