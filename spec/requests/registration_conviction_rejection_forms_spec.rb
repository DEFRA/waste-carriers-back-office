# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationConvictionRejectionForms", type: :request do
  let(:registration) { create(:registration, :has_flagged_conviction_check) }

  describe "GET /bo/registrations/:reg_identifier/convictions/reject" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_with_refund) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template, returns a 200 response, and includes the reg identifier" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/reject"

        expect(response).to render_template(:new)
        expect(response).to have_http_status(200)
        expect(response.body).to include(registration.reg_identifier)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/reject"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/registrations/:reg_identifier/convictions/reject" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_with_refund) }
      before(:each) do
        sign_in(user)
      end

      let(:params) do
        {
          revoked_reason: "foo"
        }
      end

      it "redirects to the convictions page, refuses the registration, and updates the revoked_reason, workflow_state, and 'confirmed_' attributes" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", params: { conviction_rejection_form: params }

        expect(response).to redirect_to(convictions_path)

        expect(registration.reload.metaData.revoked_reason).to eq(params[:revoked_reason])
        expect(registration.reload.metaData.status).to eq("REFUSED")

        expect(registration.reload.conviction_sign_offs.first.confirmed_at).to be_a(DateTime)
        expect(registration.reload.conviction_sign_offs.first.confirmed_by).to eq(user.email)
        expect(registration.reload.conviction_sign_offs.first.workflow_state).to eq("rejected")
      end

      context "when the params are invalid" do
        let(:params) do
          {
            revoked_reason: ""
          }
        end

        it "renders the new template, and does not update the revoked_reason" do
          post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", params: { conviction_rejection_form: params }

          expect(response).to render_template(:new)
          expect(registration.reload.metaData.revoked_reason).to_not eq(params[:revoked_reason])
        end
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
        sign_in(user)
      end

      let(:params) do
        {
          revoked_reason: "foo"
        }
      end

      it "redirects to the permissions error page, and does not update the revoked_reason" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", params: { conviction_rejection_form: params }

        expect(response).to redirect_to("/bo/pages/permission")
        expect(registration.reload.metaData.revoked_reason).to_not eq(params[:revoked_reason])
      end
    end
  end
end
