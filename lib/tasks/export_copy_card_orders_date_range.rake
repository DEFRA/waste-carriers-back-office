# frozen_string_literal: true

namespace :reports do
  namespace :export do
    desc "Run the weekly copy card orders export for a specified date range, and upload it to S3."
    task :date_range_copy_card_orders, %i[start_date end_date] => :environment do |_task, args|
      start_date = args[:start_date].present? ? Date.parse(args[:start_date]) : Time.zone.today
      end_date = args[:end_date].present? ? Date.parse(args[:end_date]) : Time.zone.today
      # The report queries up to but not including the end time
      # So specify the end time as 00:00:00 on the day after the (inclusive) end date
      Reports::CardOrdersExportService.run(
        start_time: start_date.midnight,
        end_time: (end_date + 1.day).midnight
      )
    end
  end
end
