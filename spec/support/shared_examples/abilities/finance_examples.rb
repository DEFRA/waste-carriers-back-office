# frozen_string_literal: true

RSpec.shared_examples "finance examples" do
  # All finance users should be able to do this:
  it "should be able to record a transfer payment" do
    should be_able_to(:record_transfer_payment, transient_registration)
  end

  # All finance users should NOT be able to do this:

  it "should not be able to update a transient registration" do
    should_not be_able_to(:update, transient_registration)
  end

  it "should not be able to renew" do
    should_not be_able_to(:renew, transient_registration)
    should_not be_able_to(:renew, registration)
  end

  it "should not be able to record a cash payment" do
    should_not be_able_to(:record_cash_payment, transient_registration)
  end

  it "should not be able to record a cheque payment" do
    should_not be_able_to(:record_cheque_payment, transient_registration)
  end

  it "should not be able to record a postal order payment" do
    should_not be_able_to(:record_postal_order_payment, transient_registration)
  end

  it "should not be able to review convictions" do
    should_not be_able_to(:review_convictions, transient_registration)
  end

  it "should not be able to view revoked reasons" do
    should_not be_able_to(:view_revoked_reasons, transient_registration)
  end

  it "should not be able to revert to payment summary" do
    should_not be_able_to(:revert_to_payment_summary, transient_registration)
  end

  it "should not be able to transfer a registration" do
    should_not be_able_to(:transfer_registration, registration)
  end
end
