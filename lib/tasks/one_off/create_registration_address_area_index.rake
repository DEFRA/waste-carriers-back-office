# frozen_string_literal: true

namespace :one_off do
  desc "Create area index for registrations"
  task create_registration_address_area_index: :environment do
    WasteCarriersEngine::Registration.collection.indexes.create_one("addresses.area": 1)
  end
end
