# frozen_string_literal: true

RSpec.shared_examples "agency examples" do
  # All agency users should be able to do this:

  it "should be able to update a transient registration" do
    should be_able_to(:update, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to charge adjust a resource" do
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  it "should be able to renew" do
    should be_able_to(:renew, WasteCarriersEngine::RenewingRegistration)
    should be_able_to(:renew, WasteCarriersEngine::Registration)
  end

  it "should be able to edit a registration" do
    # TODO: Remove once edit is no longer behind a feature toggle
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:edit_registration).and_return(true)

    should be_able_to(:edit, WasteCarriersEngine::Registration)
  end

  it "should be able to review convictions" do
    should be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to write off large" do
    should_not be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
  end

  it "should be able to transfer a registration" do
    should be_able_to(:transfer_registration, WasteCarriersEngine::Registration)
  end

  it "should be able to revert to payment summary" do
    should be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration)
  end

  # All agency users should NOT be able to do this:

  it "should not be able to modify finance users" do
    user = build(:user, :finance)
    should_not be_able_to(:modify_user, user)
  end
end
