# frozen_string_literal: true

namespace :reports do
  namespace :export do
    desc "Run the weekly copy card orders export up to end of day yesterday, and upload it to S3."
    task generate_finance_reports: :environment do
      unless WasteCarriersEngine::FeatureToggle.active?(:finance_reports)
        Rails.logger.info "Finance reports export skipped: feature toggle 'finance_reports' is not active"
        next
      end

      Reports::FinanceReportsService.run
    end
  end
end
