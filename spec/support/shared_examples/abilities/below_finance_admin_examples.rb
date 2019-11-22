# frozen_string_literal: true

RSpec.shared_examples "below_finance_admin examples" do
  it "should_not be able to record a worldpay payment" do
    should_not be_able_to(:record_worldpay_missed_payment, transient_registration)
  end
end
