# frozen_string_literal: true

class AdReminderLettersExport < ReminderLettersExport
  validates :expires_on, uniqueness: true

  def export!
    AdReminderLettersExportService.run(self)
  end
end
