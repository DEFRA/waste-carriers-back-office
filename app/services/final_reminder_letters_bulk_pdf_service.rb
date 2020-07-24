# frozen_string_literal: true

class FinalReminderLettersBulkPdfService < ReminderLettersBulkPdfService

  private

  def error_label
    "final digital reminder"
  end

  def template
    "final_reminder_letters/bulk"
  end

  def presenter
    FinalReminderLetterPresenter
  end
end
