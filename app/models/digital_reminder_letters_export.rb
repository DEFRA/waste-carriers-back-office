# frozen_string_literal: true

class DigitalReminderLettersExport < ReminderLettersExport
  def export!
    DigitalReminderLettersExportService.run(self)
  end
end
