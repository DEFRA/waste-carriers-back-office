# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserGroupRolesService do
  describe ".call" do
    let(:user) { instance_double(User) }

    context 'when user role is either "cbd_user" or "agency_with_refund"' do
      %w[cbd_user agency_with_refund].each do |role|
        before do
          allow(user).to receive(:role).and_return(role)
        end

        it "returns ['data_agent'] for #{role} role" do
          expect(described_class.call(user)).to eq(["data_agent"])
        end
      end
    end

    context "when user is in agency group" do
      before do
        allow(user).to receive(:role).and_return("some_other_role")
        allow(user).to receive(:in_agency_group?).and_return(true)
      end

      it "returns AGENCY_ROLES" do
        expect(described_class.call(user)).to eq(User::AGENCY_ROLES)
      end
    end

    context "when user is in finance group" do
      before do
        allow(user).to receive(:role).and_return("some_other_role")
        allow(user).to receive(:in_agency_group?).and_return(false)
        allow(user).to receive(:in_finance_group?).and_return(true)
      end

      it "returns FINANCE_ROLES" do
        expect(described_class.call(user)).to eq(User::FINANCE_ROLES)
      end
    end

    context "when user does not fit any predefined group" do
      before do
        allow(user).to receive(:role).and_return("some_other_role")
        allow(user).to receive(:in_agency_group?).and_return(false)
        allow(user).to receive(:in_finance_group?).and_return(false)
      end

      it "returns an empty array" do
        expect(described_class.call(user)).to eq([])
      end
    end
  end
end
