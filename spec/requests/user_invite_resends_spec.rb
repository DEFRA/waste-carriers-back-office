# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Invite Resends" do
  before do
    allow(Notifications::Client).to receive(:new).and_return(
      instance_double(Notifications::Client, send_email: nil)
    )
  end

  let(:current_user_role) { :agency_super }
  let(:subject_user_role) { :agency }
  let(:invited_user) do
    user = build(:user, role: subject_user_role)
    user.invite!
    user
  end
  let(:active_user) { create(:user, role: subject_user_role) }

  describe "GET /bo/users/:id/resend-invite" do
    context "when a super user is signed in" do
      let(:user) { create(:user, role: current_user_role) }

      before do
        sign_in(user)
      end

      context "when the current user has permission to modify the user" do
        context "when the user has a pending invitation" do
          it "renders the new template" do
            get "/bo/users/#{invited_user.id}/resend-invite"

            expect(response).to render_template(:new)
          end
        end

        context "when the user has already accepted their invitation" do
          it "redirects to the user list" do
            get "/bo/users/#{active_user.id}/resend-invite"

            expect(response).to redirect_to(users_path)
          end
        end
      end

      context "when the current user does not have permission to manage back office users" do
        let(:current_user_role) { :agency }

        it "redirects to a permission error" do
          get "/bo/users/#{invited_user.id}/resend-invite"

          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end

  describe "POST /bo/users/:id/resend-invite" do
    context "when a super user is signed in" do
      let(:user) { create(:user, role: current_user_role) }

      before do
        sign_in(user)
      end

      context "when the current user has permission to modify the user" do
        context "when the user has a pending invitation" do
          it "redirects to the user list and resets the invitation token" do
            original_sent_at = invited_user.invitation_sent_at

            post "/bo/users/#{invited_user.id}/resend-invite"

            expect(response).to redirect_to(users_path)
            expect(invited_user.reload.invitation_sent_at).to be > original_sent_at
          end
        end

        context "when the user has already accepted their invitation" do
          it "redirects to the user list without changes" do
            post "/bo/users/#{active_user.id}/resend-invite"

            expect(response).to redirect_to(users_path)
          end
        end
      end

      context "when the current user does not have permission to manage back office users" do
        let(:current_user_role) { :agency }

        it "redirects to a permission error" do
          post "/bo/users/#{invited_user.id}/resend-invite"

          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end
end
