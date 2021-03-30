# frozen_string_literal: true

namespace :notify do
  namespace :letters do
    desc "Send AD renewal letters"
    task ad_renewals: :environment do
      expires_on = WasteCarriersBackOffice::Application.config.ad_reminder_letters_exports_expires_in.to_i.days.from_now

      registrations = NotifyBulkAdRenewalLettersService.run(expires_on)

      if registrations.any?
        Rails.logger.info "Notify AD renewal letters sent for #{registrations.map(&:reg_identifier).join(', ')}"
      else
        Rails.logger.info "No matching registrations for Notify AD renewal letters"
      end
    end
  end

  namespace :test do
    desc "Send a test renewal letter to the newest registration in the DB"
    task ad_renewal_letter: :environment do
      registration = WasteCarriersEngine::Registration.last

      NotifyRenewalLetterService.run(registration: registration)
    end
  end
end
