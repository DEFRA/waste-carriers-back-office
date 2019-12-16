# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersHelper, type: :helper do
  describe "#display_user_actions?" do
    let(:in_agency_group) {}
    let(:in_finance_group) {}
    let(:displayed_user) do
      double(:displayed_user,
             in_agency_group?: in_agency_group,
             in_finance_group?: in_finance_group)
    end
    let(:current_user) do
      double(:current_user,
             can: false)
    end

    context "when the displayed user is an agency user" do
      let(:in_agency_group) { true }
      let(:in_finance_group) { false }

      context "when the current user has permission to manage agency users" do
        before do
          expect(current_user).to receive(:can?).with(:manage_agency_users, displayed_user).and_return(true)
        end

        it "returns true" do
          expect(helper.display_user_actions?(displayed_user, current_user)).to eq(true)
        end
      end

      context "when the current user does not have permission to manage agency users" do
        before do
          expect(current_user).to receive(:can?).with(:manage_agency_users, displayed_user).and_return(false)
        end

        it "returns false" do
          expect(helper.display_user_actions?(displayed_user, current_user)).to eq(false)
        end
      end
    end

    context "when the displayed user is an finance user" do
      let(:in_agency_group) { false }
      let(:in_finance_group) { true }

      context "when the current user has permission to manage finance users" do
        before do
          expect(current_user).to receive(:can?).with(:manage_finance_users, displayed_user).and_return(true)
        end

        it "returns true" do
          expect(helper.display_user_actions?(displayed_user, current_user)).to eq(true)
        end
      end

      context "when the current user does not have permission to manage finance users" do
        before do
          expect(current_user).to receive(:can?).with(:manage_finance_users, displayed_user).and_return(false)
        end

        it "returns false" do
          expect(helper.display_user_actions?(displayed_user, current_user)).to eq(false)
        end
      end
    end
  end
end
