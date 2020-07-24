# frozen_string_literal: true

class AdReminderLettersExportService < ReminderLettersExportService

  private

  def bulk_pdf_service
    AdReminderLettersBulkPdfService
  end

  def error_label
    "assisted digital reminder"
  end

  def file_name
    @_file_name ||= lambda do
      date = @reminder_letters_export.expires_on.to_formatted_s(:plain_year_month_day)

      "ad_reminder_letters_#{date}.pdf"
    end.call
  end

  def registrations
    @_registrations ||= lambda do
      from = @reminder_letters_export.expires_on.beginning_of_day
      to = @reminder_letters_export.expires_on.end_of_day

      WasteCarriersEngine::Registration
        .order_by(reg_identifier: "ASC")
        .in(contact_email: [WasteCarriersEngine.configuration.assisted_digital_email, nil, ""])
        .where(expires_on: { :$lte => to, :$gte => from })
    end.call
  end
end
