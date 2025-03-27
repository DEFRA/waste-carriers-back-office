# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:deactivate_inactive_users", type: :task do
  include_context "rake"
  let(:rake_task) { Rake::Task["one_off:deactivate_inactive_users"] }
  let(:active_user) { create(:user, active: true, role:) }

  after { rake_task.reenable }

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

  describe "dry run mode" do
    let(:role) { "agency" }

    before { active_user.update(last_sign_in_at: 3.months.ago) }

    it "does not deactivate the user" do
      expect { rake_task.invoke("dry_run") }.not_to change { active_user.reload.active }
    end
  end
end
