# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Activations", type: :request do
  let(:current_user_role) { :agency_super }
  let(:subject_user_role) { :agency }
  let(:active_user) { create(:user, role: subject_user_role) }
  let(:inactive_user) { create(:user, :inactive, role: subject_user_role) }

  describe "GET /bo/users/:id/activate" do
    context "when a super user is signed in" do
      let(:user) { create(:user, role: current_user_role) }
      before(:each) do
        sign_in(user)
      end

      context "when the current user has permission to activate the user" do
        context "when the user to be activated is inactive" do
          it "renders the new template" do
            get "/bo/users/#{inactive_user.id}/activate"

            expect(response).to render_template(:new)
          end
        end

        context "when the user to be activated is already active" do
          it "redirects to the user list" do
            get "/bo/users/#{active_user.id}/activate"

            expect(response).to redirect_to(users_path)
          end
        end
      end

      context "when the current user does not have permission to activate the user" do
        let(:current_user_role) { :finance_super }

        it "redirects to a permission error" do
          get "/bo/users/#{inactive_user.id}/activate"

          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end

  describe "POST /bo/users/:id/activate" do
    context "when a super user is signed in" do
      let(:user) { create(:user, role: current_user_role) }
      before(:each) do
        sign_in(user)
      end

      context "when the current user has permission to activate the user" do
        context "when the user to be activated is inactive" do
          it "redirects to the user list and activates the user" do
            post "/bo/users/#{inactive_user.id}/activate"

            expect(response).to redirect_to(users_path)
            expect(inactive_user.reload.active?).to eq(true)
          end
        end

        context "when the user to be activated is already active" do
          it "redirects to the user list" do
            post "/bo/users/#{active_user.id}/activate"

            expect(response).to redirect_to(users_path)
          end
        end
      end

      context "when the current user does not have permission to activate the user" do
        let(:subject_user_role) { :finance }

        it "redirects to a permission error" do
          post "/bo/users/#{inactive_user.id}/activate"

          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end
end
