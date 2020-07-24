# frozen_string_literal: true

class ReminderLettersExportCleanerService < ::WasteCarriersEngine::BaseService
  def run(older_than)
    export
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
    Rails.logger.error "Failed to delete #{export.name} older_than #{older_than}:\n#{e}"
  end

  private

  # Implement in subclasses

  def export
    raise NotImplementedError
  end
end
