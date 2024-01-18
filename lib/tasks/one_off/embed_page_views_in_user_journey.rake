# frozen_string_literal: true

namespace :one_off do
  desc "Embed standalone page_views in their user_journeys"
  task embed_page_views_in_user_journey: :environment do

    # Need to drop below mongoid to the ruby driver as the rails model has
    # changed since the data being migrated was created
    client = Mongoid::Clients.default
    session = client.start_session
    collection = Mongoid::Clients.default[:analytics_page_views]

    collection.find.each do |page_view|
      user_journey = WasteCarriersEngine::Analytics::UserJourney.where(id: page_view[:user_journey_id]).first
      next if user_journey.blank?

      session.with_transaction do
        user_journey.page_views.create(page_view.except(:_id, :user_journey_id))
        collection.delete_one(_id: page_view[:_id])
      end
    end
  end
end
