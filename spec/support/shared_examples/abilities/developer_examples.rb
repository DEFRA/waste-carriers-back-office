# frozen_string_literal: true

RSpec.shared_examples "developer examples" do
  it "is able to toggle features" do
    expect(subject).to be_able_to(:manage, WasteCarriersEngine::FeatureToggle)
  end

  it "is able to view DEFRA quarterly reports" do
    expect(subject).to be_able_to(:read, Reports::DefraQuarterlyStatsService)
  end

  it "is able to manage email exports" do
    expect(subject).to be_able_to(:read, DeregistrationEmailExportService)
  end

  it "is not able to charge adjust a resource" do
    expect(subject).not_to be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  include_examples "finance_report examples"

end
