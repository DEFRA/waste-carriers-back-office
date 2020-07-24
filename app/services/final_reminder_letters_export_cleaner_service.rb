# frozen_string_literal: true

class FinalReminderLettersExportCleanerService < ReminderLettersExportCleanerService

  private

  def export
    FinalReminderLettersExport
  end
end
