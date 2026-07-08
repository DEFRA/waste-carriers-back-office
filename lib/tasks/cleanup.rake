# frozen_string_literal: true

namespace :cleanup do
  desc "Remove old transient_registrations from the database"
  task transient_registrations: :environment do
    TransientRegistrationCleanupService.run
  end

  desc "Remove obsolete deregistration_token fields from registrations"
  task deregistration_tokens: :environment do
    DeregistrationTokenCleanupService.run
  end
end
