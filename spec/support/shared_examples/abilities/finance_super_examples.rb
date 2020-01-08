# frozen_string_literal: true

RSpec.shared_examples "finance_super examples" do
  # Finance super users can only manage users:
  it "should be able to manage back office users" do
    should be_able_to(:manage_back_office_users, User)
  end

  it "should be able to manage finance users" do
    should be_able_to(:manage_finance_users, User)
  end

  # Everything else is off-limits.

  it "should not be able to view the certificate" do
    should_not be_able_to(:view_certificate, WasteCarriersEngine::Registration)
  end

  it "should not be able to update a transient registration" do
    should_not be_able_to(:update, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to renew" do
    should_not be_able_to(:renew, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:renew, WasteCarriersEngine::Registration)
  end

  it "should not be able to refund a payment" do
    should_not be_able_to(:refund, WasteCarriersEngine::Registration)
  end

  it "should not be able to record a cash payment" do
    should_not be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to record a cheque payment" do
    should_not be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to record a postal order payment" do
    should_not be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to record a transfer payment" do
    should_not be_able_to(:record_transfer_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to record a worldpay payment" do
    should_not be_able_to(:record_worldpay_missed_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to review convictions" do
    should_not be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to view revoked reasons" do
    should_not be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to revert to payment summary" do
    should_not be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to transfer a registration" do
    should_not be_able_to(:transfer_registration, WasteCarriersEngine::Registration)
  end

  it "should not be able to manage agency users" do
    should_not be_able_to(:manage_agency_users, User)
  end
end
