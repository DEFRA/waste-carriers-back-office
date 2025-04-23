# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopyCardsForm do
  subject { build(:order_copy_cards_registration, workflow_state: "copy_cards_form") }

  describe "#workflow_state" do
    context "with :copy_cards_form state transitions" do
      context "with :next transition" do
        it_behaves_like "has next transition", next_state: "copy_cards_payment_form"
      end
    end
  end
end
