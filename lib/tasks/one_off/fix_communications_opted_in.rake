# frozen_string_literal: true

namespace :one_off do
  desc "Set communications_opted_in for all registrations where expires_on is within the last 40 months"
  task fix_communications_opted_in: :environment do
    regs_with_unset_opted_in = WasteCarriersEngine::Registration.where(
      communications_opted_in: nil,
      expires_on: { "$gte": 40.months.ago.beginning_of_day }
    )

    if regs_with_unset_opted_in.any?
      puts "Updating #{regs_with_unset_opted_in.count} registration(s)" unless Rails.env.test?
      time_start = Time.zone.now
      WasteCarriersEngine::Registration.collection.update_many(
        { communications_opted_in: nil, expires_on: { "$gte": 40.months.ago.beginning_of_day } },
        { "$set": { communications_opted_in: true } }
      )
      time_end = Time.zone.now
      puts "Finished updating registrations in #{time_end - time_start} seconds" unless Rails.env.test?
    else
      puts "No registrations with unset communications_opted_in found." unless Rails.env.test?
    end
  end
end
