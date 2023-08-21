# frozen_string_literal: true

namespace :one_off do
  desc "Clear LOWER tier registrations with conviction flags"
  task clear_lower_tier_with_conviction_flags: :environment do
    registration_ids = scope
    registration_ids.each do |id|
      registration = WasteCarriersEngine::Registration.find(id)
      registration.conviction_sign_offs.destroy_all
      registration.save
    end
  end

  def scope
    WasteCarriersEngine::Registration.collection.aggregate(lower_tier_conviction_pipeline).pluck(:_id)
  end

  def lower_tier_conviction_pipeline
    [
      # Match registrations with the desired tier
      { "$match": { tier: "LOWER" } },

      # Add a field to calculate the size of the conviction_sign_offs array
      { "$addFields": { numConvictions: { "$size": { "$ifNull": ["$convictionSignOffs", []] } } } },

      # Filter out documents where conviction_sign_offs is empty or does not exist
      { "$match": { numConvictions: { "$eq": 0 } } },

      # Project only the _id (registration id) for further processing
      { "$project": { _id: 1 } }
    ]
  end
end
