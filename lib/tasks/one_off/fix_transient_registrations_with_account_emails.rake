# frozen_string_literal: true

namespace :one_off do
  desc "Fix transient registrations with account email address"
  task fix_transient_registrations_with_account_emails: :environment do
    affected_transient_regs_count = count_transient_registration_ids_with_account_email_present
    if affected_transient_regs_count.positive?
      puts "Removing account email field from transient registrations"
      puts "#{affected_transient_regs_count} registration(s) affected"
      WasteCarriersEngine::TransientRegistration.collection.update_many(
        {},
        { "$unset": { accountEmail: 1 } }
      )
    else
      puts "No transient registrations with account email address found."
    end
  end
end

def count_transient_registration_ids_with_account_email_present
  WasteCarriersEngine::TransientRegistration.collection.find({ accountEmail: { "$exists": true } }).count
end
