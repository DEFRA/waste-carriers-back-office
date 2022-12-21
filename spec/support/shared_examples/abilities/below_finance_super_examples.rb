# frozen_string_literal: true

RSpec.shared_examples "below finance_super examples" do
  it "is not able to manage back office users" do
    expect(subject).not_to be_able_to(:manage_back_office_users, User)
  end

  it "is not able to modify finance users" do
    user = build(:user, role: :finance)
    expect(subject).not_to be_able_to(:modify_user, user)
  end
end
