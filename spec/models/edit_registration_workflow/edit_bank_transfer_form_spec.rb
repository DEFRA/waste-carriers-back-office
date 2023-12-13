# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditBankTransferForm do
  subject { build(:edit_registration, workflow_state: "edit_bank_transfer_form") }

  describe "#workflow_state" do
    context "with :payment_summary_form state transitions" do
      context "with :next transition" do
        include_examples "has next transition", next_state: "edit_complete_form"
      end
    end
  end
end
