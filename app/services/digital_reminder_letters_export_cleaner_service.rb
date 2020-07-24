# frozen_string_literal: true

class DigitalReminderLettersExportCleanerService < ReminderLettersExportCleanerService

  private

  def export
    DigitalReminderLettersExport
  end
end
