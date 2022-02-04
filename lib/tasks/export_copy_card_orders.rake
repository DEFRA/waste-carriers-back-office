# frozen_string_literal: true

namespace :reports do
  namespace :export do
    desc "Run the weekly copy card orders export up to end of day yesterday, and upload it to S3."
    task weekly_copy_card_orders: :environment do

      # Run the report for one week up to end of day yesterday
      end_date = Date.today.midnight
      start_date = end_date - 1.week
      Reports::CardOrdersExportService.new(start_date, end_date).run
    end
  end
end
