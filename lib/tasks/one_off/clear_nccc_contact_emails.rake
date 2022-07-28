# frozen_string_literal: true

namespace :one_off do
  desc "Clear NCCC contact emails"
  task clear_nccc_contact_emails: :environment do
    ClearNcccContactEmailsService.run
  end
end
