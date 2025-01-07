# frozen_string_literal: true

namespace :expire_registration do
  desc "Set the status of expired registations to expired"
  task run: :environment do
    expired_registrations_count = ExpiredRegistrationsService.run
    StdoutLogger.log "#{expired_registrations_count} expired registration(s) have been set to expired"
  end
end
