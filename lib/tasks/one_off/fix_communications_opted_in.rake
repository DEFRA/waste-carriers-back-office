# frozen_string_literal: true

namespace :one_off do
  desc "Create registration unsubscribe_token index"
  task fix_communications_opted_in: :environment do
    regs_with_unset_opted_in = WasteCarriersEngine::Registration.active.upper_tier.where(communications_opted_in: nil)

    if regs_with_unset_opted_in.count.positive?
      puts "Updating #{regs_with_unset_opted_in.count} registration(s)" unless Rails.env.test?
      WasteCarriersEngine::Registration.collection.update_many(
        { tier: "UPPER", "metaData.status": "ACTIVE", communications_opted_in: nil },
        { "$set": { communications_opted_in: true } }
      )
    else
      puts "No active upper tier registrations with unset communications_opted_in found." unless Rails.env.test?
    end
  end
end
