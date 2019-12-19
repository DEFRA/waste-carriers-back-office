# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Activations", type: :request do
  let(:active_user) { create(:user, :agency) }
  let(:inactive_user) { create(:user, :agency, :inactive) }

  before { allow_any_instance_of(User).to receive(:valid?).and_return(true) }

  describe "GET /bo/users/activate/:id" do
    context "when a super user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      context "when the user to be activated is inactive" do
        it "renders the activate_form template" do
          get "/bo/users/activate/#{inactive_user.id}"
          expect(response).to render_template(:activate_form)
        end
      end

      context "when the user to be activated is already active" do
        it "redirects to the user list" do
          get "/bo/users/activate/#{active_user.id}"
          expect(response).to redirect_to(users_path)
        end
      end
    end
  end

  describe "GET /bo/users/deactivate/:id" do
    context "when a super user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      context "when the user to be deactivated is active" do
        it "renders the deactivate_form template" do
          get "/bo/users/deactivate/#{active_user.id}"
          expect(response).to render_template(:deactivate_form)
        end
      end

      context "when the user to be deactivated is already inactive" do
        it "redirects to the user list" do
          get "/bo/users/deactivate/#{inactive_user.id}"
          expect(response).to redirect_to(users_path)
        end
      end
    end
  end

  describe "POST /bo/users/activate" do
    context "when a super user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      context "when the user to be activated is inactive" do
        it "redirects to the user list" do
          post "/bo/users/activate/#{inactive_user.id}"
          expect(response).to redirect_to(users_path)
        end

        it "activates the user" do
          post "/bo/users/activate/#{inactive_user.id}"
          expect(inactive_user.reload.active?).to eq(true)
        end
      end

      context "when the user to be activated is already active" do
        it "redirects to the user list" do
          post "/bo/users/activate/#{active_user.id}"
          expect(response).to redirect_to(users_path)
        end
      end
    end
  end

  describe "POST /bo/users/deactivate" do
    context "when a super user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      context "when the user to be deactivated is active" do
        it "redirects to the user list" do
          post "/bo/users/deactivate/#{active_user.id}"
          expect(response).to redirect_to(users_path)
        end

        it "deactivates the user" do
          post "/bo/users/deactivate/#{active_user.id}"
          expect(active_user.reload.active?).to eq(false)
        end
      end

      context "when the user to be deactivated is already inactive" do
        it "redirects to the user list" do
          post "/bo/users/deactivate/#{inactive_user.id}"
          expect(response).to redirect_to(users_path)
        end
      end
    end
  end
end
