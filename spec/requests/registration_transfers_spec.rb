# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationTransfers", type: :request do
  let(:registration) { create(:registration) }
  let(:other_external_user) { create(:external_user) }

  describe "GET /bo/registrations/:reg_identifier/transfer" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/registrations/#{registration.reg_identifier}/transfer/"
        expect(response).to render_template(:new)
      end

      it "includes the registration info on the page" do
        get "/bo/registrations/#{registration.reg_identifier}/transfer/"
        expect(response.body).to include("Transfer registration #{registration.reg_identifier}")
      end

      it "returns a 200 response" do
        get "/bo/registrations/#{registration.reg_identifier}/transfer/"
        expect(response).to have_http_status(200)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/registrations/#{registration.reg_identifier}/transfer/"
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/registrations/#{registration.reg_identifier}/transfer/"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/registration/:reg_identifier/transfer" do
    let(:params) do
      {
        email: other_external_user.email,
        confirm_email: other_external_user.email
      }
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      context "when the params are valid" do
        it "redirects to the success page" do
          post "/bo/registrations/#{registration.reg_identifier}/transfer/", registration_transfer_form: params
          expect(response).to redirect_to("/bo/registrations/#{registration.reg_identifier}/transfer/success")
        end

        it "changes the account_email" do
          post "/bo/registrations/#{registration.reg_identifier}/transfer/", registration_transfer_form: params
          expect(registration.reload.account_email).to eq(params[:email])
        end
      end

      context "when the params are invalid" do
        let(:params) do
          {
            email: nil,
            confirm_email: nil
          }
        end

        it "renders the new template" do
          post "/bo/registrations/#{registration.reg_identifier}/transfer/", registration_transfer_form: params
          expect(response).to render_template(:new)
        end

        it "does not change the account_email" do
          old_email = registration.account_email
          post "/bo/registrations/#{registration.reg_identifier}/transfer/", registration_transfer_form: params
          expect(registration.reload.account_email).to eq(old_email)
        end
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/registrations/#{registration.reg_identifier}/transfer/", registration_transfer_form: params
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        post "/bo/registrations/#{registration.reg_identifier}/transfer/", registration_transfer_form: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
