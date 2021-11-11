# frozen_string_literal: true

namespace :remove_deletable_registrations do
  desc "Remove deletable registrations"
  task run: :environment do
    RemoveDeletableRegistrationsService.run
  end
end
