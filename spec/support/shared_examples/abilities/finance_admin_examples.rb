# frozen_string_literal: true

RSpec.shared_examples "finance_admin examples" do
  it "should be able to record a worldpay payment" do
    should be_able_to(:record_worldpay_missed_payment, transient_registration)
  end
end
