# frozen_string_literal: true

RSpec.shared_examples "cbd user examples" do
  it "is able to manage back office users" do
    is_expected.to be_able_to(:manage_back_office_users, User)
  end

  it "is able to modify data_agent users" do
    user = build(:user, role: :data_agent)
    is_expected.to be_able_to(:modify_user, user)
  end

  it "is not able to modify agency users" do
    user = build(:user, role: :agency)
    is_expected.not_to be_able_to(:modify_user, user)
  end

  it "is not able to modify finance users" do
    user = build(:user, role: :finance)
    is_expected.not_to be_able_to(:modify_user, user)
  end
end
