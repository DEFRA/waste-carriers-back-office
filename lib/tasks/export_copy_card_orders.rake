# frozen_string_literal: true

namespace :reports do
  namespace :export do
    desc "Run the weekly copy card orders export up to end of day yesterday, and upload it to S3."
    task weekly_copy_card_orders: :environment do

      # Run the report for one week up to end of day on the most recent Monday
      # So the end time is 00:00:00 on the Tuesday after that Monday
      end_date = (Time.zone.today.prev_occurring(:monday) + 1.day).midnight
      start_date = end_date - 1.week
      Reports::CardOrdersExportService.run(
        start_time: start_date.midnight,
        end_time: end_date.midnight
      )
    end
  end
end
