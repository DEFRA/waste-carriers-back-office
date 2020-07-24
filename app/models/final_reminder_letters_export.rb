# frozen_string_literal: true

class FinalReminderLettersExport < ReminderLettersExport
  def export!
    FinalReminderLettersExportService.run(self)
  end
end
