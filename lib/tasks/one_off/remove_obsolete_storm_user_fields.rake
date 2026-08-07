# frozen_string_literal: true

namespace :one_off do
  desc "Remove obsolete Storm fields from back office users"
  task remove_obsolete_storm_user_fields: :environment do
    result = User.collection.update_many({}, { "$unset": { storm_user_id: 1, call_recording_state: 1 } })

    puts "Removed obsolete Storm fields from #{result.modified_count} user(s)" unless Rails.env.test?
  end
end
