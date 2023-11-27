# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :notify do
  namespace :notifications do
    desc "Run bulk digital renewal notification service"
    task digital_renewals: :environment do
      expires_on = WasteCarriersBackOffice::Application.config
                                                       .digital_reminder_notifications_exports_expires_in
                                                       .to_i
                                                       .days
                                                       .from_now

      registrations = Notify::BulkDigitalRenewalNotificationService.run(expires_on)

      if registrations.any?
        Rails.logger.info(
          "Notify digital renewal notifications sent for #{registrations.map(&:reg_identifier).join(', ')}"
        )
      else
        Rails.logger.info "No matching registrations for Notify digital renewal notifications"
      end
    end
  end

  namespace :letters do
    desc "Send AD renewal letters"
    task ad_renewals: :environment do
      expires_on = WasteCarriersBackOffice::Application.config
                                                       .ad_reminder_letters_exports_expires_in
                                                       .to_i
                                                       .days
                                                       .from_now

      registrations = Notify::BulkAdRenewalLettersService.run(expires_on)

      if registrations.any?
        Rails.logger.info "Notify AD renewal letters sent for #{registrations.map(&:reg_identifier).join(', ')}"
      else
        Rails.logger.info "No matching registrations for Notify AD renewal letters"
      end
    end

    desc "Send digital renewal letters"
  end

  namespace :test do
    desc "Send a test AD renewal letter to the newest registration in the DB"
    task ad_renewal_letter: :environment do
      registration = WasteCarriersEngine::Registration.last

      Notify::AdRenewalLetterService.run(registration: registration)
    end

    desc "Send a test digital renewal letter to the newest registration in the DB"
    task digital_renewal_letter: :environment do
      registration = WasteCarriersEngine::Registration.last

      Notify::DigitalRenewalLetterService.run(registration: registration)
    end
  end
end
# rubocop:enable Metrics/BlockLength
