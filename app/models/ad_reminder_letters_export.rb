# frozen_string_literal: true

class AdReminderLettersExport < ReminderLettersExport
  def export!
    AdReminderLettersExportService.run(self)
  end
end
