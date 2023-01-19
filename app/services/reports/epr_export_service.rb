# frozen_string_literal: true

require_relative "../concerns/can_load_file_to_aws"

module Reports
  class EprExportService < ::WasteCarriersEngine::BaseService
    include CanLoadFileToAws

    def run
      populate_temp_file

      options = { s3_directory: "EPR" }

      load_file_to_aws_bucket(options)
    rescue StandardError => e
      Airbrake.notify e, file_name: file_name
      Rails.logger.error "Generate EPR export csv error for #{file_name}:\n#{e}"
    ensure
      FileUtils.rm_f(file_path)
    end

    private

    def populate_temp_file
      # Write the registrations first, then use the registration ids
      # for de-duplication while writing the renewing_registrations
      epr_serializer = EprSerializer.new(path: file_path, processed_ids: nil)
      epr_serializer.to_csv do |csv|
        EprRenewalSerializer.new(path: nil, processed_ids: epr_serializer.registration_ids).to_csv(csv: csv)
      end
    end

    def file_path
      Rails.root.join("tmp/#{file_name}.csv")
    end

    def file_name
      WasteCarriersBackOffice::Application.config.epr_export_filename
    end

    def bucket_name
      WasteCarriersBackOffice::Application.config.epr_reports_bucket_name
    end
  end
end
