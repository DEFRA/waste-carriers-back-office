# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Export copy card orders task", type: :rake do
  include_context "rake"

  describe "reports:export:weekly_copy_card_orders" do

    it "uses the correct start and end times" do
      # The end time should be 00:00:00 on the most recent Monday, including today.
      # The report queries for orders with activation date less than the end time.
      expected_end_time = (Date.today.prev_occurring(:sunday) + 1.day).midnight
      expected_start_time = expected_end_time - 1.week
      expect_any_instance_of(Reports::CardOrdersExportService).to receive(:initialize)
        .with(expected_start_time, expected_end_time)
      subject.invoke
    end

    it "runs without error" do
      expect_any_instance_of(Reports::CardOrdersExportService).to receive(:run)
      expect { subject.invoke }.not_to raise_error
    end
  end
end
