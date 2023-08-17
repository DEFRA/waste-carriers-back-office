# frozen_string_literal: true

namespace :one_off do
  desc "Clear LOWER tier registrations with conviction flags"
  task clear_lower_tier_with_conviction_flags: :environment do
    registration_ids = scope
    registration_ids.each do |id|
      registration = WasteCarriersEngine::Registration.find(id)
      registration.conviction_sign_off = nil
      registration.save
    end
  end

  def scope
    WasteCarriersEngine::Registration.collection.aggregate(pipeline).pluck(:_id)
  end

  def pipeline
    [
      # Match registrations with the desired tier
      { "$match": { "tier": "LOWER" } },

      # Check if conviction_sign_off exists and is not null
      { "$match": { "convictionSignOff": { "$exists": true, "$ne": nil } } },

      # Project only the _id for the output
      { "$project": { _id: 1 } }
    ]
  end
end
