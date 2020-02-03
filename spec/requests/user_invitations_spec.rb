# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Invitations", type: :request do
  describe "GET /bo/users/invitation/new" do
    context "when a super user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/users/invitation/new"
        expect(response).to render_template(:new)
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/users/invitation/new"
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/users/invitation" do
    let(:email) { attributes_for(:user)[:email] }
    let(:role) { attributes_for(:user)[:role] }
    let(:params) do
      { user: { email: email, role: role } }
    end

    context "when a super user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the users path" do
        post "/bo/users/invitation", params
        expect(response).to redirect_to(users_path)
      end

      it "creates a new user" do
        old_user_count = User.count

        post "/bo/users/invitation", params
        expect(User.count).to eq(old_user_count + 1)
      end

      it "assigns the correct role to the user" do
        post "/bo/users/invitation", params
        expect(User.find_by(email: email).role).to eq(role)
      end

      context "when the current user does not have permission to select this role" do
        let(:role) { :finance }

        it "does not create a new user" do
          old_user_count = User.count

          post "/bo/users/invitation", params
          expect(User.count).to eq(old_user_count)
        end

        it "renders the new template" do
          post "/bo/users/invitation", params
          expect(response).to render_template(:new)
        end
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/users/invitation", params
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "PUT /bo/users/invitation" do
    let(:user) { build(:user) }
    let(:password) { attributes_for(:user)[:password] }
    let(:params) do
      {
        user: {
          password: password,
          confirm_password: password,
          invitation_token: user.raw_invitation_token
        }
      }
    end

    before do
      user.invite!
    end

    context "when the user accepts an invitation and sets a valid password" do
      it "redirects to the back office dashboard path" do
        put "/bo/users/invitation", params
        expect(response).to redirect_to(bo_path)
      end
    end
  end
end
