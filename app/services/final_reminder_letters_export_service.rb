# frozen_string_literal: true

require_relative "concerns/can_load_file_to_aws"

class FinalReminderLettersExportService < ::WasteCarriersEngine::BaseService
  include CanLoadFileToAws

  def run(final_reminder_letters_export)
    @final_reminder_letters_export = final_reminder_letters_export

    if registrations.any?
      File.open(file_path, "w:ASCII-8BIT") do |file|
        file.write(FinalReminderLettersBulkPdfService.run(registrations))
      end

      load_file_to_aws_bucket
    end

    record_content_created
  rescue StandardError => e
    Airbrake.notify e, file_name: file_name
    Rails.logger.error "Generate AD confirmation letters export error for #{file_name}:\n#{e}"

    record_content_errored
  ensure
    File.unlink(file_path) if File.exist?(file_path)
  end

  private

  def file_path
    @_file_path ||= Rails.root.join("tmp/#{file_name}")
  end

  def file_name
    @_file_name ||= lambda do
      date = @final_reminder_letters_export.expires_on.to_formatted_s(:plain_year_month_day)

      "final_reminder_letters_#{date}.pdf"
    end.call
  end

  def registrations
    @_registrations ||= lambda do
      from = @final_reminder_letters_export.expires_on.beginning_of_day
      to = @final_reminder_letters_export.expires_on.end_of_day

      WasteCarriersEngine::Registration
        .order_by(reg_identifier: "ASC")
        .not_in(contact_email: [WasteCarriersEngine.configuration.assisted_digital_email, nil, ""])
        .where(expires_on: { :$lte => to, :$gte => from })
    end.call
  end

  def bucket_name
    WasteCarriersBackOffice::Application.config.letters_export_bucket_name
  end

  def record_content_created
    @final_reminder_letters_export.number_of_letters = registrations.count
    @final_reminder_letters_export.file_name = file_name

    @final_reminder_letters_export.save!
    @final_reminder_letters_export.succeeded!
  end

  def record_content_errored
    @final_reminder_letters_export.failed!
  end
end
