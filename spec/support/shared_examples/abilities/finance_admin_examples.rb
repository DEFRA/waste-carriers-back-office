# frozen_string_literal: true

RSpec.shared_examples "finance_admin examples" do
  # Finance admin users can only do two things:
  it "should be able to record a worldpay payment" do
    should be_able_to(:record_worldpay_missed_payment, WasteCarriersEngine::RenewingRegistration.new)
  end

  it "should be able to view the certificate" do
    should be_able_to(:view_certificate, WasteCarriersEngine::Registration.new)
  end

  # Everything else is off-limits.

  it "should not be able to update a transient registration" do
    should_not be_able_to(:update, WasteCarriersEngine::RenewingRegistration.new)
  end

  it "should not be able to renew" do
    should_not be_able_to(:renew, WasteCarriersEngine::RenewingRegistration.new)
    should_not be_able_to(:renew, WasteCarriersEngine::Registration.new)
  end

  it "should not be able to record a cash payment" do
    should_not be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration.new)
  end

  it "should not be able to record a cheque payment" do
    should_not be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration.new)
  end

  it "should not be able to record a postal order payment" do
    should_not be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration.new)
  end

  it "should not be able to record a transfer payment" do
    should_not be_able_to(:record_transfer_payment, WasteCarriersEngine::RenewingRegistration.new)
  end

  it "should not be able to review convictions" do
    should_not be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration.new)
  end

  it "should not be able to view revoked reasons" do
    should_not be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration.new)
  end

  it "should not be able to revert to payment summary" do
    should_not be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration.new)
  end

  it "should not be able to manage back office users" do
    should_not be_able_to(:manage_back_office_users, User.new)
  end

  it "should not be able to create an agency user" do
    should_not be_able_to(:create_agency_user, User.new)
  end

  it "should not be able to create an agency_with_refund user" do
    should_not be_able_to(:create_agency_with_refund_user, User.new)
  end

  it "should not be able to create a finance user" do
    should_not be_able_to(:create_finance_user, User.new)
  end

  it "should not be able to create a finance admin user" do
    should_not be_able_to(:create_finance_admin_user, User.new)
  end

  it "should not be able to transfer a registration" do
    should_not be_able_to(:transfer_registration, WasteCarriersEngine::Registration.new)
  end
end
