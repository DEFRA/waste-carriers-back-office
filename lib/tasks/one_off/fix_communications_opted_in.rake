# frozen_string_literal: true

namespace :one_off do
  desc "Create registration unsubscribe_token index"
  task fix_communications_opted_in: :environment do
    regs_with_unset_opted_in = WasteCarriersEngine::Registration.where(
      communications_opted_in: nil,
      expires_on: { "$gte": 40.days.ago.beginning_of_day }
    )

    if regs_with_unset_opted_in.count.positive?
      puts "Updating #{regs_with_unset_opted_in.count} registration(s)" unless Rails.env.test?
      WasteCarriersEngine::Registration.collection.update_many(
        { communications_opted_in: nil, expires_on: { "$gte": 40.days.ago.beginning_of_day } },
        { "$set": { communications_opted_in: true } }
      )
    else
      puts "No registrations with unset communications_opted_in found." unless Rails.env.test?
    end
  end
end
