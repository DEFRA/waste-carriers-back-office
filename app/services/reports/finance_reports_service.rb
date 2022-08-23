# frozen_string_literal: true

require "zip"

module Reports
  class FinanceReportsService < ::WasteCarriersEngine::BaseService

    def run
      @tmp_dir = Dir.mktmpdir
      @report_timestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")

      generate_csv_files

      zip_report_files
    end

    # This is public so that the caller can retrieve the report path for download.
    def report_file_path
      File.join(@tmp_dir,
                "#{WasteCarriersBackOffice::Application.config.finance_report_filename_prefix}" \
                "#{@report_timestamp}.zip")
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
      Zip::File.open(report_file_path, Zip::File::CREATE) do |zipfile|
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
  end
end
