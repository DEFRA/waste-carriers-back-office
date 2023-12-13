# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ConfirmEditCancelledForms" do
  describe "GET new_confirm_edit_cancelled_form_path" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      context "when no edit registration exists" do
        it "redirects to the invalid page" do
          get new_confirm_edit_cancelled_form_path("wibblewobblejellyonaplate")

          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a valid edit registration exists" do
        let(:transient_registration) do
          create(:edit_registration,
                 workflow_state: "confirm_edit_cancelled_form")
        end

        it "returns a 200 status" do
          get new_confirm_edit_cancelled_form_path(transient_registration.token)

          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "POST confirm_edit_cancelled_form_path" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      context "when no edit registration exists" do
        it "redirects to the invalid page" do
          post confirm_edit_cancelled_forms_path("wibblewobblejellyonaplate")

          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a valid edit registration exists" do
        let(:transient_registration) do
          create(:edit_registration,
                 workflow_state: "confirm_edit_cancelled_form")
        end

        it "redirects to the edit cancelled page" do
          post confirm_edit_cancelled_forms_path(transient_registration.token)

          expect(response).to redirect_to(new_edit_cancelled_form_path(transient_registration.token))
        end
      end
    end
  end
end
