# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Export copy card orders task", type: :rake do
  subject { Rake.application["reports:export:weekly_copy_card_orders"] }

  include_context "rake"

  # Reset @already_invoked between tests to allow multiple invocations of the same Rake task
  before { Rake.application["reports:export:weekly_copy_card_orders"].reenable }

  RSpec.shared_examples "runs the report" do |report_run_time|

    context "with a given report run date and time" do
      around do |example|
        Timecop.freeze(report_run_time) do
          example.run
        end
      end

      it "uses the correct start and end times" do
        # The report runs from Tuesday 00:00:00 (inclusive) to Tuesday 00:00:00 (non-inclusive).
        # The end day should be the day after the most recent Monday, excluding today (if Monday).
        # Examples:
        #   Run time Monday 21st at 2:30    => Report range: Tuesday  7th at 00:00:00 <= T < Tuesday 15th at 00:00:00
        #   Run time Tuesday 22nd at 2:30   => Report range: Tuesday 15th at 00:00:00 <= T < Tuesday 22nd at 00:00:00
        #   Run time Wednesday 23rd at 2:30 => Report range: Tuesday 15th at 00:00:00 <= T < Tuesday 22nd at 00:00:00
        expected_end_time = (Time.zone.today.prev_occurring(:monday) + 1.day).midnight
        expected_start_time = expected_end_time - 1.week
        expect(Reports::CardOrdersExportService).to receive(:run)
          .with(start_time: expected_start_time, end_time: expected_end_time)
        Rake.application["reports:export:weekly_copy_card_orders"].invoke
      end
    end
  end

  describe "reports:export:weekly_copy_card_orders" do

    # This cop should not fire when a block argument is used, but it does, |n|:
    # rubocop:disable Style/EachForSimpleLoop
    context "when excluding Monday" do
      first_run_date = Faker::Date.in_date_period
      # check all weekdays and skip Monday
      (0..6).each do |n|
        run_date = first_run_date + n.days
        next if Date::DAYNAMES[run_date.wday] == "Monday"

        it_behaves_like "runs the report", run_date.noon
      end
    end
    # rubocop:enable Style/EachForSimpleLoop

    # The logic of this spec is the same as the shared example but it is
    # broken out explicitly here for clarity as Monday is an edge case.
    context "when on Monday" do
      let(:run_date) { Faker::Date.in_date_period.prev_occurring(:monday) }
      let(:expected_end_time) { run_date.prev_occurring(:tuesday).midnight }
      let(:expected_start_time) { expected_end_time - 1.week }

      around do |example|
        Timecop.freeze(run_date.noon) do
          example.run
        end
      end

      it "runs the report up to the end of the previous Monday" do
        expect(Reports::CardOrdersExportService).to receive(:run)
          .with(start_time: expected_start_time, end_time: expected_end_time)
        Rake.application["reports:export:weekly_copy_card_orders"].invoke
      end
    end
  end
end
