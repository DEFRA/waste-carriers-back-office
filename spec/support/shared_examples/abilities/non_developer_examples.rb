# frozen_string_literal: true

RSpec.shared_examples "non-developer examples" do
  it "is not able to toggle features" do
    expect(subject).not_to be_able_to(:manage, WasteCarriersEngine::FeatureToggle)
  end

  it "is not able to view DEFRA quarterly reports" do
    expect(subject).not_to be_able_to(:read, Reports::DefraQuarterlyStatsService) unless user.role == "agency_super"
  end
end
