# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users tasks" do

  after { rake_task.reenable }

  describe "users:deactivate_inactive_users", type: :task do
    include_context "rake"
    let(:rake_task) { Rake::Task["users:deactivate_inactive_users"] }
    let(:active_user) { create(:user, active: true, role:) }

    it { expect { rake_task.invoke }.not_to raise_error }

    context "when the user has not signed in for over 3 months" do
      let(:role) { "agency" }

      before { active_user.update(last_sign_in_at: 3.months.ago) }

      it "deactivates the user" do
        expect { rake_task.invoke }.to change { active_user.reload.active }.to(false)
      end

      context "when the user is a agency" do
        it "deactivates the user" do
          expect { rake_task.invoke }.to change { active_user.reload.active }.to(false)
        end
      end

      context "when the user is an agency_super" do
        let(:role) { "agency_super" }

        it "does not deactivate the user" do
          expect { rake_task.invoke }.not_to change { active_user.reload.active }
        end
      end

      context "when the user is a developer" do
        let(:role) { "developer" }

        it "does not deactivate the user" do
          expect { rake_task.invoke }.not_to change { active_user.reload.active }
        end
      end
    end

    context "when the user has signed in within the last 3 months" do
      let(:role) { "agency" }

      before do
        active_user.update(last_sign_in_at: 1.month.ago, role:)
      end

      it "does not deactivate the user" do
        expect { rake_task.invoke }.not_to change { active_user.reload.active }
      end
    end

    context "when the user has never signed in" do
      let(:role) { "agency" }

      context "when invited more than 3 months ago" do
        before do
          active_user.update(last_sign_in_at: nil, invitation_created_at: 4.months.ago)
        end

        it "deactivates the user" do
          expect { rake_task.invoke }.to change { active_user.reload.active }.to(false)
        end
      end

      context "when invited within the last 3 months" do
        before do
          active_user.update(last_sign_in_at: nil, invitation_created_at: 2.months.ago)
        end

        it "does not deactivate the user" do
          expect { rake_task.invoke }.not_to change { active_user.reload.active }
        end
      end
    end

    describe "dry run mode" do
      let(:role) { "agency" }

      before { active_user.update(last_sign_in_at: 3.months.ago) }

      it "does not deactivate the user" do
        expect { rake_task.invoke("dry_run") }.not_to change { active_user.reload.active }
      end
    end
  end

  describe "users:fix_signed_in_accounts_with_expired_invitations" do
    include_context "rake"

    let(:rake_task) { Rake::Task["users:fix_signed_in_accounts_with_expired_invitations"] }

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
               invitation_sent_at: 4.weeks.ago,
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
end
