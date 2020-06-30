# frozen_string_literal: true

namespace :letters do
  namespace :export do
    desc "Generate a bulk export PDF file of final renewal reminder letters"
    task final_reminders: :environment do
      expires_on = WasteCarriersBackOffice::Application.config.final_reminder_letters_exports_expires_in.to_i

      FinalReminderLettersExport.find_or_create_by(
        expires_on: expires_on.days.from_now
      ).export!

      older_than = WasteCarriersBackOffice::Application.config.final_reminder_letters_delete_records_in.to_i.days.ago

      FinalReminderLettersExportCleanerService.run(older_than)
    end
  end
end
