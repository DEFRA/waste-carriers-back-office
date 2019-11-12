# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMigrationService do
  let(:service) do
    UserMigrationService.run
  end

  describe "#run" do
    before do
      create(:role)
    end

    context "when there are no backend users" do
      it "does not modify the back office users" do
        users_before_sync = User.all
        service
        expect(User.all).to eq(users_before_sync)
      end
    end

    context "when there is a backend agency_user who isn't in the back office" do
      let!(:agency_user) { create(:agency_user) }
      let(:matching_back_office_user) { User.where(email: agency_user.email).first }

      it "creates a new back office user" do
        number_of_users_before_sync = User.all.count
        service
        expect(User.all.count).to eq(number_of_users_before_sync + 1)
      end

      it "uses the correct email" do
        service
        expect(matching_back_office_user.email).to eq(agency_user.email)
      end

      it "uses the correct role" do
        service
        expect(matching_back_office_user.role).to eq("agency")
      end

      context "when the role is agency_with_refund" do
        before do
          role = create(:role, :agency_with_refund, agency_user_ids: [agency_user.id])
          agency_user.update_attributes(role_ids: [role.id])
        end

        it "uses the correct role" do
          service
          expect(matching_back_office_user.role).to eq("agency_with_refund")
        end
      end

      context "when the role is finance" do
        before do
          role = create(:role, :finance, agency_user_ids: [agency_user.id])
          agency_user.update_attributes(role_ids: [role.id])
        end

        it "uses the correct role" do
          service
          expect(matching_back_office_user.role).to eq("finance")
        end
      end

      context "when the role is finance_admin" do
        before do
          role = create(:role, :finance_admin, agency_user_ids: [agency_user.id])
          agency_user.update_attributes(role_ids: [role.id])
        end

        it "uses the correct role" do
          service
          expect(matching_back_office_user.role).to eq("finance_admin")
        end
      end

      it "adds the correct value to the results" do
        result = {
          action: :create,
          email: agency_user.email,
          role: "agency"
        }

        expect(service).to include(result)
      end
    end

    context "when there is a backend admin who isn't in the back office" do
      let!(:admin) { create(:admin) }
      let(:matching_back_office_user) { User.where(email: admin.email).first }

      it "creates a new back office user" do
        number_of_users_before_sync = User.all.count
        service
        expect(User.all.count).to eq(number_of_users_before_sync + 1)
      end

      it "uses the correct email" do
        service
        expect(matching_back_office_user.email).to eq(admin.email)
      end

      it "uses the correct role" do
        service
        expect(matching_back_office_user.role).to eq("agency_super")
      end

      context "when the role is finance_super" do
        before do
          role = create(:role, :finance_super, agency_user_ids: [admin.id])
          admin.update_attributes(role_ids: [role.id])
        end

        it "uses the correct role" do
          service
          expect(matching_back_office_user.role).to eq("finance_super")
        end
      end

      it "adds the correct value to the results" do
        result = {
          action: :create,
          email: admin.email,
          role: "agency_super"
        }

        expect(service).to include(result)
      end
    end

    context "when there is a backend user who is in the back office" do
      let!(:agency_user) { create(:agency_user) }
      let!(:back_office_user) { create(:user, email: agency_user.email) }

      context "when the role is the same" do
        it "does not modify the back office user" do
          back_office_user_before = back_office_user
          service
          back_office_user_after = back_office_user.reload
          expect(back_office_user_before).to eq(back_office_user_after)
        end

        it "adds the correct value to the results" do
          result = {
            action: :skip,
            email: agency_user.email,
            role: "agency"
          }

          expect(service).to include(result)
        end
      end

      context "when the role is different" do
        before do
          back_office_user.update_attributes(role: "finance")
        end

        it "updates the back office user role" do
          role_before = back_office_user.role
          service
          role_after = back_office_user.reload.role
          expect(role_before).to_not eq(role_after)
        end

        it "adds the correct value to the results" do
          result = {
            action: :update,
            email: agency_user.email,
            role: "agency"
          }

          expect(service).to include(result)
        end
      end
    end
  end
end
