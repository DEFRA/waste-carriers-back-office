# frozen_string_literal: true

RSpec.shared_examples "finance_report examples" do
  it "should be able to run finance reports" do
    should be_able_to(:run_finance_reports, :all)
  end
end
