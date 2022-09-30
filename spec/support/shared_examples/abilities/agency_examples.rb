# frozen_string_literal: true

RSpec.shared_examples "agency examples" do
  # All agency users should be able to do this:

  it "is able to update a transient registration" do
    should be_able_to(:update, WasteCarriersEngine::RenewingRegistration)
  end

  it "is able to create a registration" do
    should be_able_to(:create, WasteCarriersEngine::Registration)
  end

  it "is not able to charge adjust a resource" do
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  it "is able to renew" do
    should be_able_to(:renew, WasteCarriersEngine::RenewingRegistration)
    should be_able_to(:renew, WasteCarriersEngine::Registration)
  end

  it "is able to edit a registration" do
    should be_able_to(:edit, WasteCarriersEngine::Registration)
  end

  it "is not able to write off large" do
    should_not be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
  end

  it "is able to transfer a registration" do
    should be_able_to(:transfer_registration, WasteCarriersEngine::Registration)
  end

  it "is able to revert to payment summary" do
    should be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration)
  end

  it "is able to resend a confirmation email" do
    should be_able_to(:resend_confirmation_email, WasteCarriersEngine::Registration)
  end

  it "is able to refresh the company name" do
    should be_able_to(:refresh_company_name, WasteCarriersEngine::Registration)
  end

  # All agency users should NOT be able to do this:

  it "is not able to modify finance users" do
    user = build(:user, :finance)
    should_not be_able_to(:modify_user, user)
  end
end
