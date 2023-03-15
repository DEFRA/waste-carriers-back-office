# frozen_string_literal: true

require "zip"

class DeregistrationEmailExportService < WasteCarriersEngine::BaseService
  include CanLoadFileToAws

  def run(batch_size)
    @batch_size = batch_size

    Dir.mktmpdir do |dir_path|
      @tmp_dir = dir_path

      serializer.to_csv

      load_file_to_aws_bucket(s3_directory: s3_directory)

      EmailExportLog.new(file_name, report_timestamp).save!
    end
  rescue StandardError => e
    Airbrake.notify e
    Rails.logger.error "Error generating email export:\n#{e}"
  ensure
    # In case of failure before the temporary directory gets cleaned up:
    FileUtils.rm_f(file_path)
  end

  private

  def serializer
    DeregistrationEmailExportSerializer.new(
      file_path,
      "Lower-tier deregistration email",
      "0001e85a-7a09-4d6d-8988-ffb6fe4e2fd2",
      @batch_size
    )
  end

  def file_path
    @file_path ||= File.join(@tmp_dir, file_name)
  end

  def report_timestamp
    @report_timestamp ||= Time.zone.now
  end

  def file_name
    "lower_tier_dereg_emails_#{@batch_size}_#{report_timestamp.strftime('%Y-%m-%d_%H-%M-%S')}.csv"
  end

  def bucket
    @bucket ||= DefraRuby::Aws.get_bucket(bucket_name)
  end

  def bucket_name
    @bucket_name ||= WasteCarriersBackOffice::Application.config.email_exports_bucket_name
  end

  def s3_directory
    @s3_directory ||= WasteCarriersBackOffice::Application.config.email_exports_directory
  end
end
