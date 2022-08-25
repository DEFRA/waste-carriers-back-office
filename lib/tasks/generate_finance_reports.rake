# frozen_string_literal: true

namespace :reports do
  namespace :export do
    desc "Run the weekly copy card orders export up to end of day yesterday, and upload it to S3."
    task generate_finance_reports: :environment do
      Reports::FinanceReportsService.run
    end
  end
end
