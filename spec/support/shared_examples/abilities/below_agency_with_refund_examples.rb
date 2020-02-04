# frozen_string_literal: true

RSpec.shared_examples "below agency_with_refund examples" do
  it "should not be able to view revoked reasons" do
    should_not be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to refund a payment" do
    should_not be_able_to(:refund, WasteCarriersEngine::Registration)
  end

  it "should not be able to cease a registration" do
    should_not be_able_to(:cease, WasteCarriersEngine::Registration)
  end

  it "should not be able to revoke a registration" do
    should_not be_able_to(:revoke, WasteCarriersEngine::Registration)
  end

  it "should not be able to write off small" do
    should_not be_able_to(:write_off_small, WasteCarriersEngine::FinanceDetails)
  end
end
