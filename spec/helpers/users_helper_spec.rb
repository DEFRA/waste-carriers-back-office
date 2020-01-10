# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersHelper, type: :helper do
  describe "#display_user_actions?" do
    let(:displayed_user) { double(:displayed_user) }
    let(:current_user) { double(:current_user, can?: false) }

    context "when the current user has permission to modify the displayed user" do
      before do
        expect(current_user).to receive(:can?).with(:modify_user, displayed_user).and_return(true)
      end

      it "returns true" do
        expect(helper.display_user_actions?(displayed_user, current_user)).to eq(true)
      end
    end

    context "when the current user does not have permission to manage agency users" do
      before do
        expect(current_user).to receive(:can?).with(:modify_user, displayed_user).and_return(false)
      end

      it "returns false" do
        expect(helper.display_user_actions?(displayed_user, current_user)).to eq(false)
      end
    end
  end

  describe "#display_user_actions?" do
    let(:in_agency_group) { false }
    let(:in_finance_group) { false }
    let(:current_user) do
      double(:current_user,
             in_agency_group?: in_agency_group,
             in_finance_group?: in_finance_group)
    end

    context "when the current user is in the agency user group" do
      let(:in_agency_group) { true }

      it "returns User::AGENCY_ROLES" do
        roles = %w[list of roles]
        stub_const("User::AGENCY_ROLES", roles)
        expect(helper.current_user_group_roles(current_user)).to eq(roles)
      end
    end

    context "when the current user is in the finance user group" do
      let(:in_finance_group) { true }

      it "returns User::FINANCE_ROLES" do
        roles = %w[list of roles]
        stub_const("User::FINANCE_ROLES", roles)
        expect(helper.current_user_group_roles(current_user)).to eq(roles)
      end
    end
  end
end
