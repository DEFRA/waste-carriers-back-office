# frozen_string_literal: true

class AdReminderLettersExportCleanerService < ReminderLettersExportCleanerService

  private

  def export
    AdReminderLettersExport
  end
end
