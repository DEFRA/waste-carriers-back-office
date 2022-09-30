# frozen_string_literal: true

RSpec.shared_examples "agency_super examples" do
  it "is able to manage back office users" do
    should be_able_to(:manage_back_office_users, User)
  end

  it "is able to modify agency users" do
    user = build(:user, :agency)
    should be_able_to(:modify_user, user)
  end
end
