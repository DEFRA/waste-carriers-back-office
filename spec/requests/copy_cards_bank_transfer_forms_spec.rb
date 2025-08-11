# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CopyCardsBankTransferForms" do
  describe "GET new_copy_cards_bank_transfer_form" do

    it_behaves_like "user is not logged in", action: :get, path: :new_copy_cards_bank_transfer_form_path
    it_behaves_like "user is not authorised to perform action", action: :get, path: :new_copy_cards_bank_transfer_form_path, role: :finance

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: "agency_with_refund") }

      before { sign_in(user) }

      context "when a valid transient registration exists" do
        let(:transient_registration) do
          create(:order_copy_cards_registration, temp_cards: 3, workflow_state: "copy_cards_bank_transfer_form")
        end

        it "creates a plain new order on the transient registration every time is called" do
          expect(transient_registration.finance_details).to be_nil

          get new_copy_cards_bank_transfer_form_path(transient_registration.token)

          first_finance_details = transient_registration.reload.finance_details

          order = first_finance_details.orders.first
          order_item = order.order_items.first

          expect(first_finance_details.orders.count).to eq(1)
          expect(first_finance_details.balance).to eq(3 * Rails.configuration.card_charge)
          expect(order.order_items.count).to eq(1)
          expect(order_item.type).to eq("COPY_CARDS")
          expect(order_item.amount).to eq(3 * Rails.configuration.card_charge)

          get new_copy_cards_bank_transfer_form_path(transient_registration.token)

          second_finance_details = transient_registration.reload.finance_details

          expect(first_finance_details).not_to eq(second_finance_details)
        end
      end
    end
  end

  describe "POST new_copy_cards_bank_transfer_form" do

    it_behaves_like "user is not logged in", action: :post, path: :copy_cards_bank_transfer_forms_path
    it_behaves_like "user is not authorised to perform action", action: :post, path: :copy_cards_bank_transfer_forms_path, role: :finance

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: "agency_with_refund") }

      before { sign_in(user) }

      context "when an order is in progress" do
        let(:transient_registration) do
          create(
            :order_copy_cards_registration,
            :has_finance_details,
            workflow_state: :copy_cards_bank_transfer_form
          )
        end

        it "redirects to the completion page" do
          post_form_with_params(:copy_cards_bank_transfer_form, transient_registration.token)

          expect(response).to redirect_to(new_copy_cards_order_completed_form_path(transient_registration.token))
        end
      end
    end
  end
end
