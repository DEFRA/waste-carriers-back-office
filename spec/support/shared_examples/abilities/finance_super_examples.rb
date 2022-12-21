# frozen_string_literal: true

RSpec.shared_examples "finance_super examples" do
  it "is able to manage back office users" do
    expect(subject).to be_able_to(:manage_back_office_users, User)
  end

  it "is able to charge adjust a resource" do
    expect(subject).to be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    expect(subject).to be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  it "is able to modify finance users" do
    user = build(:user, role: :finance)
    expect(subject).to be_able_to(:modify_user, user)
  end

  include_examples "finance_report examples"
end
