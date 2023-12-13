# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopyCardsBankTransferForm do
  subject { build(:order_copy_cards_registration, workflow_state: "copy_cards_bank_transfer_form") }

  describe "#workflow_state" do
    context "with :copy_cards_bank_transfer_form state transitions" do
      context "with :next transition" do
        include_examples "has next transition", next_state: "copy_cards_order_completed_form"
      end
    end
  end
end
