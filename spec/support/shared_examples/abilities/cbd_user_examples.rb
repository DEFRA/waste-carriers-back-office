# frozen_string_literal: true

RSpec.shared_examples "cbd user examples" do
  it "should be able to manage back office users" do
    should be_able_to(:manage_back_office_users, User)
  end

  it "should be able to modify data_agent users" do
    user = build(:user, role: :data_agent)
    should be_able_to(:modify_user, user)
  end

  it "should not be able to modify agency users" do
    user = build(:user, role: :agency)
    should_not be_able_to(:modify_user, user)
  end

  it "should not be able to modify finance users" do
    user = build(:user, role: :finance)
    should_not be_able_to(:modify_user, user)
  end
end
