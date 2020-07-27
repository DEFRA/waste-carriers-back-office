# frozen_string_literal: true

require_relative "concerns/can_load_file_to_aws"

class ReminderLettersExportService < ::WasteCarriersEngine::BaseService
  include CanLoadFileToAws

  def run(reminder_letters_export)
    @reminder_letters_export = reminder_letters_export

    if registrations.any?
      File.open(file_path, "w:ASCII-8BIT") do |file|
        file.write(bulk_pdf_service.run(registrations))
      end

      load_file_to_aws_bucket
    end

    record_content_created
  rescue StandardError => e
    Airbrake.notify e, file_name: file_name
    Rails.logger.error "Generate #{error_label} letters export error for #{file_name}:\n#{e}"

    record_content_errored
  ensure
    File.unlink(file_path) if File.exist?(file_path)
  end

  private

  def file_path
    @_file_path ||= Rails.root.join("tmp/#{file_name}")
  end

  def bucket_name
    WasteCarriersBackOffice::Application.config.letters_export_bucket_name
  end

  def record_content_created
    @reminder_letters_export.number_of_letters = registrations.count
    @reminder_letters_export.file_name = file_name

    @reminder_letters_export.save!
    @reminder_letters_export.succeeded!
  end

  def record_content_errored
    @reminder_letters_export.failed!
  end

  # Implement in subclasses

  def bulk_pdf_service
    raise NotImplementedError
  end

  def error_label
    raise NotImplementedError
  end

  def file_name
    raise NotImplementedError
  end

  def registrations
    raise NotImplementedError
  end
end
