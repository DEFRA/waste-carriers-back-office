# frozen_string_literal: true

require_relative "../concerns/can_load_file_to_aws"

module Reports
  class CardOrdersExportService < ::WasteCarriersEngine::BaseService
    include CanLoadFileToAws

    def run(start_time:, end_time:)
      @start_time = start_time
      @end_time = end_time

      populate_temp_file

      options = { s3_directory: "CARD_ORDERS" }

      load_file_to_aws_bucket(options)

      log_export
    rescue StandardError => e
      Airbrake.notify e, file_name: file_name
      Rails.logger.error "Generate card orders export csv error for #{file_name}:\n#{e}"
    ensure
      FileUtils.rm_f(file_path)
    end

    private

    def populate_temp_file
      File.write(file_path, card_orders_export)
    end

    def file_path
      Rails.root.join("tmp/#{file_name}")
    end

    def file_name
      "#{WasteCarriersBackOffice::Application.config.card_orders_export_filename}" \
        "_#{Time.zone.today.strftime('%Y-%m-%d')}.csv"
    end

    def card_orders_export
      @serializer = CardOrdersExportSerializer.new(@start_time, @end_time)
      @serializer.to_csv
    end

    def bucket_name
      WasteCarriersBackOffice::Application.config.weekly_exports_bucket_name
    end

    def log_export
      CardOrdersExportLog.new(@start_time, @end_time, file_name, Time.zone.now).save!
      mark_order_items_exported
    end

    def mark_order_items_exported
      @serializer.mark_exported
    end
  end
end
