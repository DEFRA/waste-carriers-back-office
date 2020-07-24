# frozen_string_literal: true

class AdReminderLettersBulkPdfService < ReminderLettersBulkPdfService

  private

  def error_label
    "assisted digital reminder"
  end

  def template
    "ad_reminder_letters/bulk"
  end
end
