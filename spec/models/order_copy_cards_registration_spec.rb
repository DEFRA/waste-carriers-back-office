# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderCopyCardsRegistration do
  subject(:order_copy_cards_registration) { build(:order_copy_cards_registration) }

  context "with default status" do
    context "when a OrderCopyCardsRegistration is created" do
      it "has the state of :copy_cards_form" do
        expect(order_copy_cards_registration).to have_state(:copy_cards_form)
      end
    end
  end

  context "with validations" do
    describe "reg_identifier" do
      context "when a OrderCopyCardsRegistration is created" do
        it "is not valid if the reg_identifier is in the wrong format" do
          order_copy_cards_registration.reg_identifier = "foo"
          expect(order_copy_cards_registration).not_to be_valid
        end

        it "is not valid if no matching registration exists" do
          order_copy_cards_registration.reg_identifier = "CBDU999999"
          expect(order_copy_cards_registration).not_to be_valid
        end
      end
    end
  end
end
