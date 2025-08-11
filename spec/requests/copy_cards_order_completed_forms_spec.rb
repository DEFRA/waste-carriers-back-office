# frozen_string_literal: true

require "rails_helper"
require "support/shared_examples/call_recording_resumption"

RSpec.describe "CopyCardsOrderCompletedForms" do
  describe "GET new_copy_cards_order_completed_form_path" do
    let(:path) { new_copy_cards_order_completed_form_path(transient_registration.token) }

    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      context "when no transient registration exists" do
        let(:path) { new_copy_cards_order_completed_form_path("foo") }

        it "redirects to the invalid page" do
          get path

          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a valid transient registration exists" do
        let(:transient_registration) do
          create(
            :order_copy_cards_registration,
            :has_finance_details,
            workflow_state: "copy_cards_order_completed_form"
          )
        end

        it_behaves_like "resumes call recording"

        context "when the workflow_state is correct" do
          it "deletes the transient object, copy all finance details to the registration, load the confirmation page and sends an email" do
            registration = transient_registration.registration

            get path

            finance_details = registration.reload.finance_details
            order = finance_details.orders.last
            order_item = order.order_items.first

            expect(WasteCarriersEngine::TransientRegistration.count).to eq(0)

            expect(finance_details.orders.count).to eq(2)
            expect(finance_details.balance).to eq(Rails.configuration.card_charge)
            expect(order.order_items.count).to eq(1)
            expect(order_item.type).to eq("COPY_CARDS")
            expect(order_item.amount).to eq(Rails.configuration.card_charge)
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("copy_cards_order_completed_forms/new")
          end
        end
      end
    end
  end
end
