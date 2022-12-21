# frozen_string_literal: true

RSpec.shared_examples "non-finance_report examples" do
  it "is not able to run finance reports" do
    expect(subject).not_to be_able_to(:run_finance_reports, :all)
  end
end
