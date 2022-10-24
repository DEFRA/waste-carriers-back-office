# frozen_string_literal: true

RSpec.shared_examples "below agency_super examples" do
  it "should not be able to manage back office users" do
    should_not be_able_to(:manage_back_office_users, User)
  end

  it "should not be able to modify agency users" do
    user = build(:user, role: :agency)
    should_not be_able_to(:modify_user, user)
  end
end
