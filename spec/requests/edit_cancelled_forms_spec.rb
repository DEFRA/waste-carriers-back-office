# frozen_string_literal: true

require "rails_helper"

RSpec.describe "EditCancelledForms" do
  describe "GET new_edit_cancelled_form_path" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      context "when no edit registration exists" do
        it "redirects to the invalid page" do
          get new_edit_cancelled_form_path("wibblewobblejellyonaplate")
          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a valid edit registration exists" do
        let(:updated_email) { "updated@example.com" }
        let(:updated_registered_address) { build(:address, :registered, postcode: "UP1 2DT") }
        let(:updated_contact_address) { build(:address, :contact, postcode: "D1 1FF") }
        let(:updated_person) { build(:key_person, :main, first_name: "Updated") }

        let(:transient_registration) do
          create(:edit_registration,
                 workflow_state: "edit_cancelled_form")
        end

        context "when the workflow_state is correct" do
          it "deletes the transient object" do
            get new_edit_cancelled_form_path(transient_registration.token)

            expect(WasteCarriersEngine::TransientRegistration.count).to eq(0)
            expect(response).to have_http_status(:ok)
          end
        end

        context "when the workflow_state is not correct" do
          before do
            transient_registration.update(workflow_state: "declaration_form")
          end

          it "redirects to the correct page and does not delete the transient object" do
            get new_edit_cancelled_form_path(transient_registration.token)

            expect(WasteCarriersEngine::TransientRegistration.count).to eq(1)
            expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_declaration_form_path(transient_registration.token))
          end
        end
      end
    end
  end
end
