# frozen_string_literal: true

require "rails_helper"

RSpec.describe "reports:export:generate_finance_reports", type: :rake do
  include_context "rake"

  it "runs without error" do
    expect(Reports::FinanceReportsService).to receive(:run)
    expect { subject.invoke }.not_to raise_error
  end
end
