# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Invitations" do
  before do
    allow(Notifications::Client).to receive(:new).and_return(
      instance_double(Notifications::Client, send_email: nil)
    )
  end

  describe "GET /bo/users/invitation/new" do
    context "when a super user is signed in" do
      let(:user) { create(:user, role: :agency_super) }

      before do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/users/invitation/new"

        expect(response).to render_template(:new)
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
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
      {
        user: { email: email, role: role },
        commit: "Send invitation"
      }
    end

    context "when a super user is signed in" do
      let(:user) { create(:user, role: :agency_super) }

      before do
        sign_in(user)
      end

      it "redirects to the users path, creates a new user and assigns the correct role to the user" do
        old_user_count = User.count

        post "/bo/users/invitation", params: params

        expect(response).to redirect_to(users_path)
        expect(User.count).to eq(old_user_count + 1)
        expect(User.find_by(email: email).role).to eq(role)
      end

      shared_examples "user creation error" do

        it "does not create a new user" do
          expect { post "/bo/users/invitation", params: params }.not_to change(User, :count)
        end

        it "renders the new template" do
          post "/bo/users/invitation", params: params

          expect(response).to render_template(:new)
        end
      end

      context "when the current user does not have permission to select this role" do
        let(:role) { :finance }

        it_behaves_like "user creation error"
      end

      context "when the user already exists" do
        before { create(:user, email: email, role: role) }

        it_behaves_like "user creation error"
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/users/invitation", params: params

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
        put "/bo/users/invitation", params: params

        expect(response).to redirect_to(bo_path)
      end
    end
  end
end
