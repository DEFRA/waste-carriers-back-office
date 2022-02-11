# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Export copy card orders date range task", type: :rake do
  include_context "rake"

  # Reset @already_invoked between tests to allow multiple invocations of the same Rake task
  before { subject.reenable }

  subject { Rake.application["reports:export:date_range_copy_card_orders"] }

  date_format = "%d/%m/%Y"

  context "with no specified start or end date" do
    it "start and end dates default to today" do
      expect(Reports::CardOrdersExportService).to receive(:run)
        .with(start_time: Date.today.midnight, end_time: (Date.today + 1.day).midnight)
      subject.invoke
    end
  end

  context "with a specified start date and no specified end date" do
    let(:start_date) { (Date.today - rand(1..10).days) }

    it "end date defaults to today" do
      expect(Reports::CardOrdersExportService).to receive(:run)
        .with(start_time: start_date.midnight, end_time: (Date.today + 1.day).midnight)
      subject.invoke(start_date.strftime(date_format))
    end
  end

  context "with a specified start and end date" do
    let(:end_date) { Faker::Date.in_date_period }
    let(:start_date) { end_date - rand(1..10).days }

    it "runs the report from 00:00:00 on the start date to 23:59:999999 on the end date" do
      expect(Reports::CardOrdersExportService).to receive(:run)
        .with(start_time: start_date.midnight, end_time: (end_date + 1.day).midnight)
      subject.invoke(start_date.strftime(date_format), end_date.strftime(date_format))
    end
  end

end
