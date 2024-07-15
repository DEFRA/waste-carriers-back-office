# frozen_string_literal: true

namespace :one_off do
  desc "Create communications_opted_in index"
  task create_communications_opted_in_index: :environment do
    # create communications_opted_in index if it doesn't exist
    if WasteCarriersEngine::Registration.collection.indexes.map { |i| i["key"].keys }
                                        .flatten.include?("communications_opted_in")
      puts "Index on communications_opted_in already exists" unless Rails.env.test?
    else
      create_communications_opted_in_index
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
