# frozen_string_literal: true

namespace :one_off do
  desc "Fix transient registrations with account email address"
  task fix_transient_registrations_with_account_emails: :environment do
    if count_transient_registration_ids_with_account_email_present.positive?
      Rails.logger.info "Removing account email field from transient registrations..."
      WasteCarriersEngine::TransientRegistration.collection.update_many(
        {},
        { "$unset": { accountEmail: 1 } }
      )
    end
  end
end

def count_transient_registration_ids_with_account_email_present
  WasteCarriersEngine::TransientRegistration.collection.find({ accountEmail: { "$exists": true } }).count
end
