# frozen_string_literal: true

module Reports
  # This class simply adds an entry for "day" in the correct position to the monthly report attributes.
  class DailyFinanceReportSerializer < MonthlyFinanceReportSerializer
    pre_day_attributes = MonthlyFinanceReportSerializer::ATTRIBUTES.slice(:period, :year, :month)
    post_day_attributes = MonthlyFinanceReportSerializer::ATTRIBUTES.except(:period, :year, :month)
    ATTRIBUTES = pre_day_attributes.merge(day: "day").merge(post_day_attributes).freeze
  end
end
