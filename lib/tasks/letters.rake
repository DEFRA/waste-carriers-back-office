# frozen_string_literal: true

namespace :letters do
  namespace :export do
    desc "Generate a bulk export PDF file of digital renewal reminder letters"
    task digital_reminders: :environment do
      expires_on = WasteCarriersBackOffice::Application.config.digital_reminder_letters_exports_expires_in.to_i

      DigitalReminderLettersExport.find_or_create_by(
        expires_on: expires_on.days.from_now
      ).export!

      older_than = WasteCarriersBackOffice::Application.config.digital_reminder_letters_delete_records_in.to_i.days.ago

      DigitalReminderLettersExportCleanerService.run(older_than)
    end

    desc "Generate a bulk export PDF file of AD renewal reminder letters"
    task ad_reminders: :environment do
      expires_on = WasteCarriersBackOffice::Application.config.ad_reminder_letters_exports_expires_in.to_i

      AdReminderLettersExport.find_or_create_by(
        expires_on: expires_on.days.from_now
      ).export!

      older_than = WasteCarriersBackOffice::Application.config.ad_reminder_letters_delete_records_in.to_i.days.ago

      AdReminderLettersExportCleanerService.run(older_than)
    end
  end
end
