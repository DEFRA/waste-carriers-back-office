# frozen_string_literal: true

namespace :one_off do
  desc "Embed standalone page_views in their user_journeys"
  task embed_page_views_in_user_journey: :environment do

    # Need to drop below mongoid to the ruby driver as the rails model has
    # changed since the data being migrated was created
    client = Mongoid::Clients.default
    session = client.start_session
    page_views_collection = Mongoid::Clients.default[:analytics_page_views]

    user_journeys_with_page_views = page_views_collection.aggregate(
      [
        { "$group": {
          _id: "$user_journey_id",
          page_views: { "$addToSet": { page_view_id: "$_id", page: "$page", time: "$time", route: "$route" } }
        } }
      ],
      { allow_disk_use: true }
    )

    user_journeys_with_page_views.each do |uj_pvs|
      user_journey = WasteCarriersEngine::Analytics::UserJourney.find(uj_pvs[:_id])
      session.with_transaction do
        page_views = uj_pvs[:page_views].map { |pv| pv.except(:page_view_id) }
                                        .sort { |a, b| a[:time] <=> b[:time] }
        user_journey.page_views.create(page_views)
        page_views_collection.find("_id" => { "$in": uj_pvs[:page_views].pluck(:page_view_id) }).delete_many
      end
    end
  end
end
