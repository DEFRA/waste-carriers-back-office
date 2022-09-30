# frozen_string_literal: true

RSpec.shared_examples "developer examples" do
  it "is able to toggle features" do
    is_expected.to be_able_to(:manage, WasteCarriersEngine::FeatureToggle)
  end

  it "is not able to charge adjust a resource" do
    is_expected.not_to be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    is_expected.not_to be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  include_examples "finance_report examples"

end
