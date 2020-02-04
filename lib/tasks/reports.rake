# frozen_string_literal: true

namespace :reports do
  namespace :export do
    desc "Generate the EPR report and upload it to S3."
    task epr: :environment do
      Reports::EprExportService.run
    end

    desc "Generate the BOXI report (zipped) and upload it to S3."
    task boxi: :environment do
      Reports::BoxiExportService.run
    end
  end
end
