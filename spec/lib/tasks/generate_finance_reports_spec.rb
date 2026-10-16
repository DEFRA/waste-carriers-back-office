# frozen_string_literal: true

require "rails_helper"

RSpec.describe "reports:export:generate_finance_reports", type: :task do
  include_context "rake"

  before do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:finance_reports).and_return(true)
  end

  it "runs without error" do
    expect(Reports::FinanceReportsService).to receive(:run)
    expect { subject.invoke }.not_to raise_error
  end
end
