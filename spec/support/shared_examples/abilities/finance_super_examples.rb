# frozen_string_literal: true

RSpec.shared_examples "finance_super examples" do
  it "should be able to manage back office users" do
    should be_able_to(:manage_back_office_users, User)
  end

  it "should be able to charge adjust a resource" do
    should be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    should be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  it "should be able to modify finance users" do
    user = build(:user, :finance)
    should be_able_to(:modify_user, user)
  end

  include_examples "finance_report examples"
end
