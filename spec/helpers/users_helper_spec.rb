# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersHelper do
  before { allow(helper).to receive(:current_user).and_return(current_user) }

  describe "#display_user_actions?" do
    let(:displayed_user) { double(:displayed_user) }
    let(:current_user) { double(:current_user, can?: false) }

    context "when the current user has permission to modify the displayed user" do
      before do
        allow(current_user).to receive(:can?).with(:modify_user, displayed_user).and_return(true)
      end

      it "returns true" do
        expect(helper.display_user_actions?(displayed_user, current_user)).to be(true)
      end
    end

    context "when the current user does not have permission to manage agency users" do
      before do
        allow(current_user).to receive(:can?).with(:modify_user, displayed_user).and_return(false)
      end

      it "returns false" do
        expect(helper.display_user_actions?(displayed_user, current_user)).to be(false)
      end
    end
  end

  describe "#current_user_group_roles" do
    let(:current_user) { double(:current_user) }

    before do
      allow(UserGroupRolesService).to receive(:call).with(current_user).and_return(["data_agent"])
    end

    it "calls UserGroupRolesService.call" do
      expect(helper.current_user_group_roles(current_user)).to eq(["data_agent"])
    end
  end
end
