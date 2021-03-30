# frozen_string_literal: true

namespace :notify do
  namespace :test do
    desc "Send a test renewal letter to the newest registration in the DB"
    task ad_renewal_letter: :environment do
      registration = WasteCarriersEngine::Registration.last

      NotifyRenewalLetterService.run(registration: registration)
    end
  end
end
