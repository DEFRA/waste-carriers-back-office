# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Export copy card orders task", type: :rake do
  include_context "rake"

  subject { Rake.application["reports:export:weekly_copy_card_orders"] }

  # Reset @already_invoked between tests to allow multiple invocations of the same Rake task
  before { subject.reenable }

  RSpec.shared_examples "runs the report" do |report_run_time|

    context "for a given report run date and time" do
      around(:each) do |example|
        Timecop.freeze(report_run_time) do
          example.run
        end
      end

      it "uses the correct start and end times" do
        # The end time should be 00:00:00 on the most recent Monday, which may be the current day.
        # The report queries for orders with activation date less than the end time.
        expected_end_time = (Date.today.prev_occurring(:sunday) + 1.day).midnight
        expected_start_time = expected_end_time - 1.week
        expect(Reports::CardOrdersExportService).to receive(:run)
          .with(start_time: expected_start_time, end_time: expected_end_time)
        subject.invoke
      end
    end

    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "reports:export:weekly_copy_card_orders" do
    first_run_date = Faker::Date.in_date_period
    # check all weekdays
    (0..6).each do |n|
      run_date = first_run_date + n.days
      it_behaves_like "runs the report", run_date.noon
    end
  end
end
