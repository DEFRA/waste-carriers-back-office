# frozen_string_literal: true

namespace :expire_registration do
  desc "Set the status of expired registations to expired"
  task run: :environment do
    ExpiredRegistrationsService.run
  end
end
