# frozen_string_literal: true

RSpec.shared_examples "finance_report examples" do
  it "is able to run finance reports" do
    expect(subject).to be_able_to(:run_finance_reports, :all)
  end
end
