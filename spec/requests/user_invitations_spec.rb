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

      it "redirects to the root path" do
        post "/bo/users/invitation", params
        expect(response).to redirect_to(root_path)
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
    end
  end
end
