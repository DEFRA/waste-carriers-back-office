# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions" do
  describe "GET /bo/users/sign_in" do
    context "when a user is not signed in" do
      it "returns a success response" do
        get new_user_session_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /bo/users/sign_in" do
    let(:user) { create(:user) }

    context "when a user is not signed in" do
      context "when valid user details are submitted" do

        it "signs the user in, returns a 302 response and redirects to /bo" do
          post user_session_path, params: { user: { email: user.email, password: user.password } }

          expect(controller.current_user).to eq(user)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(bo_path)
        end

        it "sets the current_login_token" do
          post user_session_path, params: { user: { email: user.email, password: user.password } }

          user.reload

          expect(user.current_login_token).not_to be_nil
        end
      end
    end

    context "when the user is already logged in from a different session" do
      let(:user) { create(:user, current_login_token: Devise.friendly_token) }

      it "signs the user out and redirects due to concurrent session" do
        # Log in user
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to(bo_path)

        # The new login token simulates the token from another session
        new_login_token = Devise.friendly_token
        user.update(current_login_token: new_login_token)

        # Simulate the next request in which the check_concurrent_session before_action is triggered
        get bo_path
        expect(response).to redirect_to(new_user_session_path)
        follow_redirect!

        expect(response.body)
          .to include("Your login credentials were used in another browser. Please sign in again to continue in this browser.")
      end
    end
  end

  describe "DELETE /bo/users/sign_out" do
    context "when the user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "signs the user out, returns a 302 response, redirects to the /bo path and updates the session_token" do
        old_session_token = user.session_token

        get destroy_user_session_path

        expect(controller.current_user).to be_nil
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
        expect(user.reload.session_token).not_to eq(old_session_token)
      end

      context "when the user is inactive" do
        let(:user) { create(:user, :inactive) }

        it "signs the user out" do
          get destroy_user_session_path

          expect(controller.current_user).to be_nil
        end
      end
    end
  end
end
