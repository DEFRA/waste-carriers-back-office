# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationConvictionRejectionForms", type: :request do
  let(:registration) { create(:registration, :has_flagged_conviction_check) }

  describe "GET /bo/registrations/:reg_identifier/convictions/reject" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/reject"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/reject"
        expect(response).to have_http_status(200)
      end

      it "includes the reg identifier" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/reject"
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
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      let(:params) do
        {
          reg_identifier: registration.reg_identifier,
          revoked_reason: "foo"
        }
      end

      it "redirects to the convictions page" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", conviction_rejection_form: params
        expect(response).to redirect_to(convictions_path)
      end

      it "updates the revoked_reason" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", conviction_rejection_form: params
        expect(registration.reload.metaData.revoked_reason).to eq(params[:revoked_reason])
      end

      it "updates the conviction_sign_off's workflow_state" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", conviction_rejection_form: params
        expect(registration.reload.conviction_sign_offs.first.workflow_state).to eq("rejected")
      end

      skip "rejects the registration" do
      end

      context "when the params are invalid" do
        let(:params) do
          {
            reg_identifier: registration.reg_identifier,
            revoked_reason: ""
          }
        end

        it "renders the new template" do
          post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", conviction_rejection_form: params
          expect(response).to render_template(:new)
        end

        it "does not update the revoked_reason" do
          post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", conviction_rejection_form: params
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
          reg_identifier: registration.reg_identifier,
          revoked_reason: "foo"
        }
      end

      it "redirects to the permissions error page" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", conviction_rejection_form: params
        expect(response).to redirect_to("/bo/pages/permission")
      end

      it "does not update the revoked_reason" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/reject", conviction_rejection_form: params
        expect(registration.reload.metaData.revoked_reason).to_not eq(params[:revoked_reason])
      end
    end
  end
end
