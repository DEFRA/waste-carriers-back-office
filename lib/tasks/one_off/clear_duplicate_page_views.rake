# frozen_string_literal: true

namespace :one_off do
  desc "Remove duplicate page_views within a user_journey"
  task clear_duplicate_page_views: :environment do

    # First find the UserJourneys with duplicate page_views. Note that the duplicates might not be consecutive.

    user_journeys = WasteCarriersEngine::Analytics::UserJourney.collection.aggregate(
      [
        { "$project": {
          full_page_view_count: { "$size": "$page_views" },
          unique_page_view_count: { "$size": { "$setUnion": "$page_views.page" } }
        } },
        { "$project": {
          has_duplicates: { "$ne": [
            "$full_page_view_count", "$unique_page_view_count"
          ] }
        } },
        { "$match": { has_duplicates: true } }
      ],
      { allow_disk_use: true }
    ).pluck("_id")

    puts "Found #{user_journeys.length} user journeys with duplicate page views" unless Rails.env.test?

    # Now process each UserJourney in scope, removing only *consecutive* duplicate page_views.
    user_journeys.each do |user_journey_id|
      deduplicate(user_journey_id)
    end
  end
end

def deduplicate(user_journey_id)
  user_journey = WasteCarriersEngine::Analytics::UserJourney.find(user_journey_id)
  updated_page_views = user_journey.page_views.to_a
  previous_page_view = nil

  user_journey.page_views.each do |page_view|
    updated_page_views.delete(page_view) if page_view.page == previous_page_view&.page

    previous_page_view = page_view
  end

  user_journey.update(page_views: updated_page_views)
end
