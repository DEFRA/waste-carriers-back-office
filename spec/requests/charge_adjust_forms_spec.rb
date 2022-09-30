# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ChargeAdjustForms", type: :request do
  describe "GET /bo/resource/:_id/charge-adjust" do
    context "when a finance super user is signed in" do
      let(:user) { create(:user, :finance_super) }
      let(:renewing_registration) { create(:renewing_registration) }

      before do
        sign_in(user)
      end

      it "renders the new template and returns a 200 status" do
        get new_resource_charge_adjust_form_path(renewing_registration._id)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(200)
      end
    end

    context "when a non finance super user is signed in" do
      let(:user) { create(:user) }
      let(:renewing_registration) { create(:renewing_registration) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions page" do
        get new_resource_charge_adjust_form_path(renewing_registration._id)

        expect(response).to redirect_to("/bo/pages/permission")
        expect(response).to have_http_status(302)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get new_resource_charge_adjust_form_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/resource/:_id/charge-adjust" do
    context "when a finance super user is signed in" do
      let(:user) { create(:user, :finance_super) }
      let(:renewing_registration) { create(:renewing_registration) }

      before do
        sign_in(user)
      end

      context "when the request data are valid" do
        context "when the charge type is positive" do
          let(:params) do
            {
              charge_adjust_form: {
                charge_type: "positive"
              }
            }
          end

          it "redirects to the positive charge adjust page with a 302" do
            post resource_charge_adjust_form_path(renewing_registration._id), params: params

            expect(response).to have_http_status(302)
            expect(response).to redirect_to(resource_positive_charge_adjust_form_path(renewing_registration._id))
          end
        end

        context "when the charge type is negative" do
          let(:params) do
            {
              charge_adjust_form: {
                charge_type: "negative"
              }
            }
          end

          it "redirects to the negative charge adjust page with a 302" do
            post resource_charge_adjust_form_path(renewing_registration._id), params: params

            expect(response).to have_http_status(302)
            expect(response).to redirect_to(resource_negative_charge_adjust_form_path(renewing_registration._id))
          end
        end
      end

      context "when the request data are not valid" do
        it "returns a 200 status and renders the :new template" do
          post resource_charge_adjust_form_path(renewing_registration._id), params: {}

          expect(response).to have_http_status(200)
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
