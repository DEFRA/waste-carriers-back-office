# frozen_string_literal: true

RSpec.shared_examples "agency_with_refund examples" do
  it "should be able to view revoked reasons" do
    should be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "should be able to refund a payment" do
    should be_able_to(:refund, WasteCarriersEngine::Registration)
  end

  it "should be able to cease a registration" do
    should be_able_to(:cease, WasteCarriersEngine::Registration)
  end

  it "should be able to revoke a registration" do
    should be_able_to(:revoke, WasteCarriersEngine::Registration)
  end
end
