# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /bo/users/sign_in" do
    context "when a user is not signed in" do
      it "returns a success response" do
        get new_user_session_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /bo/users/sign_in" do
    context "when a user is not signed in" do
      context "when valid user details are submitted" do
        let(:user) { create(:user) }

        it "signs the user in" do
          post user_session_path, user: { email: user.email, password: user.password }
          expect(controller.current_user).to eq(user)
        end

        it "returns a 302 response" do
          post user_session_path, user: { email: user.email, password: user.password }
          expect(response).to have_http_status(302)
        end

        it "redirects to /bo" do
          post user_session_path, user: { email: user.email, password: user.password }
          expect(response).to redirect_to(bo_path)
        end
      end
    end
  end

  describe "DELETE /bo/users/sign_out" do
    context "when the user is signed in" do
      let(:user) { create(:user) }

      before(:each) do
        sign_in(user)
      end

      it "signs the user out" do
        get destroy_user_session_path
        expect(controller.current_user).to be_nil
      end

      it "returns a 302 response" do
        get destroy_user_session_path
        expect(response).to have_http_status(302)
      end

      it "redirects to the /bo path" do
        get destroy_user_session_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "updates the session_token" do
        old_session_token = user.session_token
        get destroy_user_session_path
        expect(user.reload.session_token).to_not eq(old_session_token)
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
