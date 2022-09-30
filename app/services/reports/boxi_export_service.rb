# frozen_string_literal: true

require "zip"
require_relative "../concerns/can_load_file_to_aws"

module Reports
  class BoxiExportService < ::WasteCarriersEngine::BaseService
    include CanLoadFileToAws

    def run
      Dir.mktmpdir do |dir_path|
        GenerateBoxiFilesService.run(dir_path)

        zip_export_files(dir_path)

        load_file_to_aws_bucket
      end
    rescue StandardError => e
      Airbrake.notify e
      Rails.logger.error "Generate BOXI export error:\n#{e}"
    ensure
      # In case of failure before the file gets generated
      FileUtils.rm_f(file_path)
    end

    private

    def zip_export_files(dir_path)
      files_search_path = File.join(dir_path, "*.csv")

      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        Dir[files_search_path].each do |export_file_path|
          zipfile.add(File.basename(export_file_path), export_file_path)
        end
      end
    end

    def file_path
      @file_path ||= Rails.root.join("tmp/#{file_name}.zip")
    end

    def file_name
      WasteCarriersBackOffice::Application.config.boxi_exports_filename
    end

    def bucket_name
      WasteCarriersBackOffice::Application.config.boxi_exports_bucket_name
    end
  end
end
