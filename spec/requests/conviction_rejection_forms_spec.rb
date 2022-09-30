# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ConvictionRejectionForms", type: :request do
  let(:transient_registration) { create(:renewing_registration, :has_flagged_conviction_check) }

  describe "GET /bo/transient-registrations/:reg_identifier/convictions/reject" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_with_refund) }

      before do
        sign_in(user)
      end

      it "renders the new template, returns a 200 response, and includes the reg identifier" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/reject"

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(transient_registration.reg_identifier)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/reject"
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/transient-registrations/:reg_identifier/convictions/reject" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_with_refund) }
      let(:params) do
        {
          revoked_reason: "foo"
        }
      end

      before do
        sign_in(user)
      end

      it "redirects to the convictions page, revokes the renewal, and updates the revoked_reason, workflow_state, and 'confirmed_' attributes" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/reject", params: { conviction_rejection_form: params }

        expect(response).to redirect_to(convictions_checks_in_progress_path)

        expect(transient_registration.reload.metaData.revoked_reason).to eq(params[:revoked_reason])
        expect(transient_registration.reload.metaData.status).to eq("REVOKED")

        expect(transient_registration.reload.conviction_sign_offs.first.confirmed_at).to be_a(DateTime)
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed_by).to eq(user.email)
        expect(transient_registration.reload.conviction_sign_offs.first.workflow_state).to eq("rejected")
      end

      context "when the params are invalid" do
        let(:params) do
          {
            revoked_reason: ""
          }
        end

        it "renders the new template, does not update the revoked_reason, and does not revoke the renewal" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/reject", params: { conviction_rejection_form: params }

          expect(response).to render_template(:new)
          expect(transient_registration.reload.metaData.revoked_reason).not_to eq(params[:revoked_reason])
          expect(transient_registration.reload.metaData.status).to eq("ACTIVE")
        end
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      let(:params) do
        {
          revoked_reason: "foo"
        }
      end

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page, does not update the revoked_reason, and does not update the conviction_sign_off" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/reject", params: { conviction_rejection_form: params }

        expect(response).to redirect_to("/bo/pages/permission")
        expect(transient_registration.reload.metaData.revoked_reason).not_to eq(params[:revoked_reason])
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed).to eq("no")
      end
    end
  end
end
