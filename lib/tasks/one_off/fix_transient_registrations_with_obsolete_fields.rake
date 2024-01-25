# frozen_string_literal: true

namespace :one_off do
  desc "Fix transient registrations with obsolete fields"
  task fix_transient_registrations_with_obsolete_fields: :environment do
    obsolete_fields_to_remove = %w[accountEmail temp_tier_check]
    obsolete_fields_to_remove.each do |field_name|
      affected_transient_regs_count = count_transient_registration_ids_with_obsolete_fields(field_name)
      if affected_transient_regs_count.positive?
        puts "Removing obsolete field `#{field_name}` from transient registrations" unless Rails.env.test?
        puts "#{affected_transient_regs_count} registration(s) affected" unless Rails.env.test?
        WasteCarriersEngine::TransientRegistration.collection.update_many(
          {},
          { "$unset": { "#{field_name}": 1 } }
        )
      else
        puts "No transient registrations with obsolete field `#{field_name}` found." unless Rails.env.test?
      end
    end
  end
end

def count_transient_registration_ids_with_obsolete_fields(field_name)
  WasteCarriersEngine::TransientRegistration.collection.find({ "#{field_name}": { "$exists": true } }).count
end
