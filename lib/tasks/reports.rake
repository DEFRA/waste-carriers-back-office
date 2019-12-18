# frozen_string_literal: true

require_relative "../close_airbrake"

namespace :reports do
  namespace :export do
    desc "Generate the EPR report and upload it to S3."
    task epr: :environment do
      Reports::EprExportService.run

      CloseAirbrake.now
    end

    desc "Generate the BOXI report (zipped) and upload it to S3."
    task boxi: :environment do
      Reports::BoxiExportService.run

      CloseAirbrake.now
    end
  end
end
