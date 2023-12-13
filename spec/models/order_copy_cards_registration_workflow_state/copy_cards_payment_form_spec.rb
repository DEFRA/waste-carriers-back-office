# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopyCardsPaymentForm do
  subject(:registration) { build(:order_copy_cards_registration, workflow_state: "copy_cards_payment_form") }

  describe "#workflow_state" do
    context "with :govpay_form state transitions" do
      context "with :next transition" do
        context "when the method is paying by card" do
          before { registration.temp_payment_method = "card" }

          include_examples "has next transition", next_state: "govpay_form"
        end

        context "when the method is not paying by card" do
          before { registration.temp_payment_method = "bank_transfer" }

          include_examples "has next transition", next_state: "copy_cards_bank_transfer_form"
        end
      end
    end
  end
end
