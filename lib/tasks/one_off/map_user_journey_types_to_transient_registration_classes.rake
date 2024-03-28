# frozen_string_literal: true

namespace :one_off do
  desc "Map user journey types to transient registration class names"
  task map_user_journey_types_to_transient_registration_classes: :environment do

    # rubocop:disable Rails/SkipsModelValidations
    WasteCarriersEngine::Analytics::UserJourney.where(journey_type: "registration")
                                               .update_all(journey_type: "NewRegistration")

    WasteCarriersEngine::Analytics::UserJourney.where(journey_type: "renewal")
                                               .update_all(journey_type: "RenewingRegistration")
    # rubocop:enable Rails/SkipsModelValidations
  end
end
