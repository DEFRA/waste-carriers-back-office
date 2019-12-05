# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationConvictionApprovalForms", type: :request do
  let(:registration) { create(:registration, :requires_conviction_check, :no_pending_payment) }

  describe "GET /bo/registrations/:reg_identifier/convictions/approve" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/approve"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/approve"
        expect(response).to have_http_status(200)
      end

      it "includes the reg identifier" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/approve"
        expect(response.body).to include(registration.reg_identifier)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
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
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(response).to redirect_to(convictions_path)
      end

      it "updates the revoked_reason" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(registration.reload.metaData.revoked_reason).to eq(params[:revoked_reason])
      end

      skip "updates the conviction_sign_off's confirmed" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(registration.reload.conviction_sign_offs.first.confirmed).to eq("yes")
      end

      skip "updates the conviction_sign_off's confirmed_at" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(registration.reload.conviction_sign_offs.first.confirmed_at).to be_a(DateTime)
      end

      skip "updates the conviction_sign_off's confirmed_by" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(registration.reload.conviction_sign_offs.first.confirmed_by).to eq(user.email)
      end

      skip "updates the conviction_sign_off's workflow_state" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(registration.reload.conviction_sign_offs.first.workflow_state).to eq("approved")
      end

      skip "when there is no pending payment" do
        it "activates the registration" do
        end

        skip "when the RegistrationCompletionService fails" do
          it "rescues the error" do
          end
        end
      end

      skip "when there is a pending payment" do
        it "does not activate the registration" do
        end
      end

      context "when the params are invalid" do
        let(:params) do
          {
            reg_identifier: registration.reg_identifier,
            revoked_reason: ""
          }
        end

        it "renders the new template" do
          post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
          expect(response).to render_template(:new)
        end

        it "does not update the revoked_reason" do
          post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
          expect(registration.reload.metaData.revoked_reason).to_not eq(params[:revoked_reason])
        end

        it "does not update the conviction_sign_off" do
          post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
          expect(registration.reload.conviction_sign_offs.first.confirmed).to eq("no")
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
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(response).to redirect_to("/bo/pages/permission")
      end

      it "does not update the revoked_reason" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(registration.reload.metaData.revoked_reason).to_not eq(params[:revoked_reason])
      end

      it "does not update the conviction_sign_off" do
        post "/bo/registrations/#{registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(registration.reload.conviction_sign_offs.first.confirmed).to eq("no")
      end
    end
  end
end
