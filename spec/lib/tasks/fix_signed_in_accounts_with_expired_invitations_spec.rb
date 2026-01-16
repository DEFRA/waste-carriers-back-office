# frozen_string_literal: true

require "rails_helper"

  describe "fix_signed_in_accounts_with_expired_invitations" do
    include_context "rake"

    after { rake_task.reenable }
  
    let(:rake_task) { Rake::Task["fix_signed_in_accounts_with_expired_invitations"] }

    after { rake_task.reenable }

    it { expect { rake_task.invoke }.not_to raise_error }

    shared_examples "it does not clear the invitation tokens" do
      it "does not clear the invitation tokens" do
        user
        expect { rake_task.invoke }.not_to change { user.reload.invitation_token }
      end
    end

    context "when user has signed in but has expired invitation" do
      let(:user) do
        create(:user,
               active: true,
               sign_in_count: 1,
               invitation_accepted_at: nil,
               invitation_sent_at: 3.weeks.ago,
               invitation_token: "sample_token",
               invitation_created_at: 8.days.ago)
      end

      it "clears the invitation tokens" do
        user
        expect { rake_task.invoke }.to change { user.reload.invitation_token }.from("sample_token").to(nil)
      end

      it "clears the invitation_created_at" do
        user
        expect { rake_task.invoke }.to change { user.reload.invitation_created_at }.to(nil)
      end

      it "clears the invitation_sent_at" do
        user
        expect { rake_task.invoke }.to change { user.reload.invitation_sent_at }.to(nil)
      end
    end

    context "when user has not signed in" do
      let(:user) do
        create(:user,
               active: true,
               sign_in_count: 0,
               invitation_accepted_at: nil,
               invitation_sent_at: 8.days.ago,
               invitation_token: "sample_token")
      end

      it_behaves_like "it does not clear the invitation tokens"
    end

    context "when invitation is not expired" do
      let(:user) do
        create(:user,
               active: true,
               sign_in_count: 1,
               invitation_accepted_at: nil,
               invitation_sent_at: 5.days.ago,
               invitation_token: "sample_token")
      end

      it_behaves_like "it does not clear the invitation tokens"
    end

    context "when user is inactive" do
      let(:user) do
        create(:user,
               active: false,
               sign_in_count: 1,
               invitation_accepted_at: nil,
               invitation_sent_at: 8.days.ago,
               invitation_token: "sample_token")
      end

      it_behaves_like "it does not clear the invitation tokens"
    end

    context "when invitation has been accepted" do
      let(:user) do
        create(:user,
               active: true,
               sign_in_count: 1,
               invitation_accepted_at: 1.day.ago,
               invitation_sent_at: 8.days.ago,
               invitation_token: "sample_token")
      end

      it_behaves_like "it does not clear the invitation tokens"
    end
  end
