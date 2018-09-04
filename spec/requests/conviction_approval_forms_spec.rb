# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ConvictionApprovalForms", type: :request do
  let(:transient_registration) { create(:transient_registration, :requires_conviction_check) }

  describe "GET /bo/transient-registrations/:reg_identifier/convictions/approve" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve"
        expect(response).to have_http_status(200)
      end

      it "includes the reg identifier" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve"
        expect(response.body).to include(transient_registration.reg_identifier)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve"
        expect(response).to redirect_to("/bo/permission")
      end
    end
  end

  describe "POST /bo/transient-registrations/:reg_identifier/convictions/approve" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      let(:params) do
        {
          reg_identifier: transient_registration.reg_identifier,
          revoked_reason: "foo"
        }
      end

      it "redirects to the transient_registration page" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(response).to redirect_to(transient_registration_path(transient_registration.reg_identifier))
      end

      it "updates the revoked_reason" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(transient_registration.reload.metaData.revoked_reason).to eq(params[:revoked_reason])
      end

      it "updates the conviction_sign_off's confirmed" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed).to eq("yes")
      end

      it "updates the conviction_sign_off's confirmed_at" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed_at).to be_a(DateTime)
      end

      it "updates the conviction_sign_off's confirmed_by" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed_by).to eq(user.email)
      end

      context "when the params are invalid" do
        let(:params) do
          {
            reg_identifier: transient_registration.reg_identifier,
            revoked_reason: ""
          }
        end

        it "renders the new template" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
          expect(response).to render_template(:new)
        end

        it "does not update the revoked_reason" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
          expect(transient_registration.reload.metaData.revoked_reason).to_not eq(params[:revoked_reason])
        end

        it "does not update the conviction_sign_off" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
          expect(transient_registration.reload.conviction_sign_offs.first.confirmed).to eq("no")
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
          reg_identifier: transient_registration.reg_identifier,
          revoked_reason: "foo"
        }
      end

      it "redirects to the permissions error page" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(response).to redirect_to("/bo/permission")
      end

      it "does not update the revoked_reason" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(transient_registration.reload.metaData.revoked_reason).to_not eq(params[:revoked_reason])
      end

      it "does not update the conviction_sign_off" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", conviction_approval_form: params
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed).to eq("no")
      end
    end
  end
end
