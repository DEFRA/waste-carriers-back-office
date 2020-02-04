# frozen_string_literal: true

RSpec.shared_examples "developer examples" do
  it "should be able to import conviction data" do
    should be_able_to(:import_conviction_data, :all)
  end

  it "should not be able to charge adjust a resource" do
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end
end
