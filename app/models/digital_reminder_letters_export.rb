# frozen_string_literal: true

class DigitalReminderLettersExport < ReminderLettersExport
  validates :expires_on, uniqueness: true

  def export!
    DigitalReminderLettersExportService.run(self)
  end
end
