# frozen_string_literal: true

require "rails_helper"

RSpec.describe "reports:export:generate_finance_reports", type: :task do
  include_context "rake"

  before { subject.reenable }

  it "runs the finance reports service when the feature toggle is active" do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:finance_reports).and_return(true)
    expect(Reports::FinanceReportsService).to receive(:run)
    expect { subject.invoke }.not_to raise_error
  end

  it "skips the export when the feature toggle is inactive" do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:finance_reports).and_return(false)
    expect(Reports::FinanceReportsService).not_to receive(:run)
    subject.invoke
  end
end
