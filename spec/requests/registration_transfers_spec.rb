# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationTransfers" do
  let(:registration) { create(:registration) }
  let(:other_external_user) { create(:external_user) }

  describe "GET /bo/registrations/:reg_identifier/transfer" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "renders the new template, includes the registration info on the page and returns a 200 response" do
        get "/bo/registrations/#{registration.reg_identifier}/transfer/"

        expect(response).to render_template(:new)
        expect(response.body).to include("Transfer registration #{registration.reg_identifier}")
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, role: :finance) }

      before do
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
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      context "when the params are valid" do
        it "redirects to the success page and changes the account_email" do
          post "/bo/registrations/#{registration.reg_identifier}/transfer/", params: { registration_transfer_form: params }

          expect(response).to redirect_to("/bo/registrations/#{registration.reg_identifier}/transfer/success")
          expect(registration.reload.account_email).to eq(params[:email])
        end
      end

      context "when the email addresses are blank" do
        let(:params) do
          {
            email: nil,
            confirm_email: nil
          }
        end

        it "renders the new template and does not change the account_email" do
          old_email = registration.account_email
          post "/bo/registrations/#{registration.reg_identifier}/transfer/", params: { registration_transfer_form: params }

          expect(response).to render_template(:new)
          expect(registration.reload.account_email).to eq(old_email)
        end
      end

      context "when the email addresses do not match" do
        let(:params) do
          {
            email: "alice@example.com",
            confirm_email: "bob@example.com"
          }
        end

        it "renders the new template and does not change the account_email" do
          old_email = registration.account_email
          post "/bo/registrations/#{registration.reg_identifier}/transfer/", params: { registration_transfer_form: params }

          expect(response).to render_template(:new)
          expect(registration.reload.account_email).to eq(old_email)
        end
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, role: :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/registrations/#{registration.reg_identifier}/transfer/", params: { registration_transfer_form: params }

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        post "/bo/registrations/#{registration.reg_identifier}/transfer/", params: { registration_transfer_form: params }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /bo/registrations/:reg_identifier/transfer/success" do
    before do
      # Page expects the registration's account email to belong to an actual user
      create(:external_user, email: registration.account_email)
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "renders the success template, includes the registration info on the page and returns a 200 response" do
        get "/bo/registrations/#{registration.reg_identifier}/transfer/success"

        expect(response).to render_template(:success)
        expect(response.body).to include("Registration #{registration.reg_identifier} has been transferred")
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, role: :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/registrations/#{registration.reg_identifier}/transfer/success"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/registrations/#{registration.reg_identifier}/transfer/success"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
