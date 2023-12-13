# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditRegistration do
  subject { build(:edit_registration, workflow_state: "confirm_edit_cancelled_form") }

  describe "#workflow_state" do
    context "with :confirm_edit_cancelled_form state transitions" do
      context "with :next transition" do
        include_examples "has next transition", next_state: "edit_cancelled_form"
      end
    end
  end
end
