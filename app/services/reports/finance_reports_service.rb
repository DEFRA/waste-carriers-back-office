# frozen_string_literal: true

require "zip"

module Reports
  class FinanceReportsService < ::WasteCarriersEngine::BaseService
    include CanLoadFileToAws
    include CanListFilesOnAws

    def run
      Dir.mktmpdir do |dir_path|
        @tmp_dir = dir_path

        @report_timestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")

        generate_csv_files

        zip_report_files

        load_file_to_aws_bucket(s3_directory: s3_directory)

        clear_s3_directory(s3_directory: s3_directory, except: ["#{s3_directory}/#{file_name}"])
      end
    rescue StandardError => e
      Airbrake.notify e
      Rails.logger.error "Error generating finance reports:\n#{e}"
    ensure
      # In case of failure before the temporary directory gets cleaned up:
      File.unlink(file_path) if File.exist?(file_path)
    end

    private

    def generate_csv_files
      write_csv_file(:mmyyyy, Reports::MonthlyFinanceReportSerializer)
      write_csv_file(:ddmmyyyy, Reports::DailyFinanceReportSerializer)
    end

    def write_csv_file(granularity, serializer_class)
      File.open(csv_file_path(granularity), "w+") do |file|
        file.write(serializer_class.new(finance_stats(granularity)).to_csv)
      end
    end

    def zip_report_files
      files_search_path = File.join(@tmp_dir, "*.csv")
      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        Dir[files_search_path].each do |report_file_path|
          zipfile.add(File.basename(report_file_path), report_file_path)
        end
      end
    end

    def finance_stats(granularity)
      Reports::FinanceStatsService.new(granularity).run
    end

    def csv_file_path(granularity)
      File.join(@tmp_dir,
                "#{WasteCarriersBackOffice::Application.config.finance_report_filename_prefix}" \
                "by_#{granularity}_#{@report_timestamp}.csv")
    end

    def file_path
      @file_path ||= File.join(@tmp_dir, file_name)
    end

    def file_name
      raise StandardError, "Finance report file name error: Timestamp not set" unless @report_timestamp

      @file_name ||= "#{WasteCarriersBackOffice::Application.config.finance_report_filename_prefix}" \
                     "#{@report_timestamp}.zip"
    end

    def bucket
      DefraRuby::Aws.get_bucket(bucket_name)
    end

    def bucket_name
      @bucket_name ||= WasteCarriersBackOffice::Application.config.finance_reports_bucket_name
      @bucket_name || (raise StandardError, "Environment variable \"FINANCE_REPORTS_BUCKET_NAME\" is undefined")
    end

    def s3_directory
      @s3_directory ||= WasteCarriersBackOffice::Application.config.finance_reports_directory
    end

    def clear_s3_directory(s3_directory:, except:)
      s3_files = list_files_in_aws_bucket(s3_directory)

      s3_files.each do |s3_file|
        next if except.include? s3_file

        bucket.delete(s3_file)
      end
    end
  end
end
