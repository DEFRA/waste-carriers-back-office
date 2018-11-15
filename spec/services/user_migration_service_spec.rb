# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMigrationService do
  let(:user_migration_service) do
    UserMigrationService.new
  end

  describe "#initialize" do
    it "should set the correct value to @results" do
      expect(user_migration_service.results).to eq([])
    end
  end

  describe "#sync" do
    before do
      create(:role)
    end

    context "when there are no backend users" do
      it "does not modify the back office users" do
        users_before_sync = User.all
        user_migration_service.sync
        expect(User.all).to eq(users_before_sync)
      end
    end

    context "when there is a backend agency_user who isn't in the back office" do
      let!(:agency_user) { create(:agency_user) }
      let(:matching_back_office_user) { User.where(email: agency_user.email).first }

      it "creates a new back office user" do
        number_of_users_before_sync = User.all.count
        user_migration_service.sync
        expect(User.all.count).to eq(number_of_users_before_sync + 1)
      end

      it "uses the correct email" do
        user_migration_service.sync
        expect(matching_back_office_user.email).to eq(agency_user.email)
      end

      it "uses the correct role" do
        user_migration_service.sync
        expect(matching_back_office_user.role).to eq("agency")
      end

      it "adds the correct value to @results" do
        result = {
          action: :create,
          email: agency_user.email,
          role: "agency"
        }
        user_migration_service.sync
        expect(user_migration_service.results).to include(result)
      end
    end

    context "when there is a backend admin who isn't in the back office" do
      let!(:admin) { create(:admin) }
      let(:matching_back_office_user) { User.where(email: admin.email).first }

      it "creates a new back office user" do
        number_of_users_before_sync = User.all.count
        user_migration_service.sync
        expect(User.all.count).to eq(number_of_users_before_sync + 1)
      end

      it "uses the correct email" do
        user_migration_service.sync
        expect(matching_back_office_user.email).to eq(admin.email)
      end

      it "uses the correct role" do
        user_migration_service.sync
        expect(matching_back_office_user.role).to eq("agency_super")
      end

      it "adds the correct value to @results" do
        result = {
          action: :create,
          email: admin.email,
          role: "agency_super"
        }
        user_migration_service.sync
        expect(user_migration_service.results).to include(result)
      end
    end

    context "when there is a backend user who is in the back office" do
      let!(:agency_user) { create(:agency_user) }
      let!(:back_office_user) { create(:user, email: agency_user.email) }

      context "when the role is the same" do
        it "does not modify the back office user" do
          back_office_user_before = back_office_user
          user_migration_service.sync
          back_office_user_after = back_office_user.reload
          expect(back_office_user_before).to eq(back_office_user_after)
        end

        it "adds the correct value to @results" do
          result = {
            action: :skip,
            email: agency_user.email,
            role: "agency"
          }
          user_migration_service.sync
          expect(user_migration_service.results).to include(result)
        end
      end

      context "when the role is different" do
        before do
          back_office_user.update_attributes(role: "finance")
        end

        it "updates the back office user role" do
          role_before = back_office_user.role
          user_migration_service.sync
          role_after = back_office_user.reload.role
          expect(role_before).to_not eq(role_after)
        end

        it "adds the correct value to @results" do
          result = {
            action: :update,
            email: agency_user.email,
            role: "agency"
          }
          user_migration_service.sync
          expect(user_migration_service.results).to include(result)
        end
      end
    end
  end
end
