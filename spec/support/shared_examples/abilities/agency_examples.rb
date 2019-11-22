# frozen_string_literal: true

RSpec.shared_examples "agency examples" do
  # All agency users should be able to do this:

  it "should be able to update a transient registration" do
    should be_able_to(:update, transient_registration)
  end

  it "should be able to renew" do
    should be_able_to(:renew, transient_registration)
    should be_able_to(:renew, registration)
  end

  it "should be able to review convictions" do
    should be_able_to(:review_convictions, transient_registration)
  end

  it "should be able to transfer a registration" do
    should be_able_to(:transfer_registration, registration)
  end

  it "should be able to revert to payment summary" do
    should be_able_to(:revert_to_payment_summary, transient_registration)
  end

  it "should be able to record a cash payment" do
    should be_able_to(:record_cash_payment, transient_registration)
  end

  it "should be able to record a cheque payment" do
    should be_able_to(:record_cheque_payment, transient_registration)
  end

  it "should be able to record a postal order payment" do
    should be_able_to(:record_postal_order_payment, transient_registration)
  end

  # All agency users should NOT be able to do this:

  it "should not be able to create an agency_with_refund user" do
    should_not be_able_to(:create_agency_with_refund_user, user)
  end

  it "should not be able to create a finance user" do
    should_not be_able_to(:create_finance_user, user)
  end

  it "should not be able to create a finance admin user" do
    should_not be_able_to(:create_finance_admin_user, user)
  end
end
