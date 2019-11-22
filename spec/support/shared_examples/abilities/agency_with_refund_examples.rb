# frozen_string_literal: true

RSpec.shared_examples "agency_with_refund examples" do
  it "should be able to view revoked reasons" do
    should be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration.new)
  end
end
