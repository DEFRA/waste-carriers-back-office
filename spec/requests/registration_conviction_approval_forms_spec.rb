# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationConvictionApprovalForms" do
  let(:registration) { create(:registration, :requires_conviction_check, :no_pending_payment) }

  describe "GET /bo/registrations/:reg_identifier/convictions/approve" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }

      before do
        sign_in(user)
      end

      it "renders the new template, returns a 200 response, and includes the reg identifier" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/approve"

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(registration.reg_identifier)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, role: :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/approve"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/registrations/:reg_identifier/convictions/approve" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:params) do
        {
          revoked_reason: "foo"
        }
      end

      before do
        sign_in(user)
      end

      it "redirects to the convictions page and updates the revoked_reason, workflow_state, and 'confirmed_' attributes" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

        expect(response).to redirect_to(convictions_path)

        expect(registration.reload.metaData.revoked_reason).to eq(params[:revoked_reason])
        expect(registration.reload.conviction_sign_offs.first.confirmed).to eq("yes")
        expect(registration.reload.conviction_sign_offs.first.confirmed_at).to be_a(DateTime)
        expect(registration.reload.conviction_sign_offs.first.confirmed_by).to eq(user.email)
        expect(registration.reload.conviction_sign_offs.first.workflow_state).to eq("approved")
      end

      context "when there is no pending payment" do
        it "activates the registration" do
          post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

          expect(registration.reload).to be_active
        end
      end

      context "when there is a pending payment" do
        let(:registration) { create(:registration, :requires_conviction_check, :pending_payment) }

        it "does not activate the registration" do
          post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

          expect(registration.reload).to be_pending
        end
      end

      context "when the params are invalid" do
        let(:params) do
          {
            reg_identifier: registration.reg_identifier,
            revoked_reason: ""
          }
        end

        it "renders the new template, does not update the revoked_reason, and does not update the conviction_sign_off" do
          post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

          expect(response).to render_template(:new)
          expect(registration.reload.metaData.revoked_reason).not_to eq(params[:revoked_reason])
          expect(registration.reload.conviction_sign_offs.first.confirmed).to eq("no")
        end
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, role: :finance) }
      let(:params) do
        {
          revoked_reason: "foo"
        }
      end

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page, does not update the revoked_reason, does not update the conviction_sign_off" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

        expect(response).to redirect_to("/bo/pages/permission")
        expect(registration.reload.metaData.revoked_reason).not_to eq(params[:revoked_reason])
        expect(registration.reload.conviction_sign_offs.first.confirmed).to eq("no")
      end
    end
  end
end
