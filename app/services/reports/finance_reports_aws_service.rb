# frozen_string_literal: true

require "zip"

module Reports
  class FinanceReportsAwsService < ::WasteCarriersEngine::BaseService
    include CanListFilesOnAws

    def download_link
      s3_files = list_files_in_aws_bucket(s3_directory)

      return nil unless s3_files.present? && s3_files.length.positive?

      file_name = s3_files.max

      bucket.presigned_url(file_name)
    end

    private

    def bucket
      @bucket ||= DefraRuby::Aws.get_bucket(bucket_name)
    end

    def bucket_name
      @bucket_name ||= WasteCarriersBackOffice::Application.config.finance_reports_bucket_name
    end

    def s3_directory
      @s3_directory ||= WasteCarriersBackOffice::Application.config.finance_reports_directory
    end
  end
end
