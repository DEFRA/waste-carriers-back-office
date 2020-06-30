# frozen_string_literal: true

class FinalReminderLettersExportCleanerService < ::WasteCarriersEngine::BaseService
  def run(older_than)
    a = FinalReminderLettersExport
      .not_deleted
      .where(
        created_at:
        {
          :$lte => older_than
        }
      )
      .map(&:deleted!)
  rescue StandardError => e
    Airbrake.notify e, older_than: older_than
    Rails.logger.error "Failed to delete FinalReminderLettersExport older_than #{older_than}:\n#{e}"
  end
end
