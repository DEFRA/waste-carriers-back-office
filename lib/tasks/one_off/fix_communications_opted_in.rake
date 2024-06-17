# frozen_string_literal: true

namespace :one_off do
  desc "Create registration unsubscribe_token index"
  task fix_communications_opted_in: :environment do
    # create communications_opted_in index if it doesn't exist
    unless WasteCarriersEngine::Registration.collection.indexes.map { |i| i["key"].keys }
                                            .flatten.include?("communications_opted_in")
      create_communications_opted_in_index
    end

    regs_with_unset_opted_in = WasteCarriersEngine::Registration.where(
      communications_opted_in: nil,
      expires_on: { "$gte": 40.months.ago.beginning_of_day }
    )

    if regs_with_unset_opted_in.count.positive?
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

def create_communications_opted_in_index
  puts "Creating index on communications_opted_in" unless Rails.env.test?
  time_start = Time.zone.now
  WasteCarriersEngine::Registration.collection.indexes.create_one(communications_opted_in: 1)
  time_end = Time.zone.now
  puts "Finished creating index in #{time_end - time_start} seconds" unless Rails.env.test?
end
