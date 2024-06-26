# frozen_string_literal: true

namespace :one_off do
  desc "Clear redundant conviction signoffs"
  task clear_invalid_conviction_signoffs: :environment do

    registrations = WasteCarriersEngine::Registration.where(
      declared_convictions: { "$ne": "yes" },
      "conviction_search_result.match_result": "NO",
      "key_people.person_type": { "$ne": "RELEVANT" },
      "metaData.last_modified": { "$gte": DateTime.parse("2024-03-01") }
    )

    registrations.each do |registration|
      registration.update(conviction_sign_offs: registration.conviction_sign_offs[0..-2])
    end
  end

  desc "Clear redundant conviction signoffs for transient registrations"
  task clear_transient_invalid_conviction_signoffs: :environment do

    transient_registrations = WasteCarriersEngine::TransientRegistration.where(
      declared_convictions: { "$ne": "yes" },
      "conviction_search_result.match_result": "NO",
      "key_people.person_type": { "$ne": "RELEVANT" },
      "metaData.last_modified": { "$gte": DateTime.parse("2024-03-01") }
    )

    transient_registrations.each do |transient_registration|
      transient_registration.update(conviction_sign_offs: transient_registration.conviction_sign_offs[0..-2])
    end
  end
end
