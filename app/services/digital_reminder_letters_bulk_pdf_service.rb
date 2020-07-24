# frozen_string_literal: true

class DigitalReminderLettersBulkPdfService < ReminderLettersBulkPdfService

  private

  def error_label
    "digital digital reminder"
  end

  def template
    "digital_reminder_letters/bulk"
  end
end
