# frozen_string_literal: true

namespace :one_off do
  desc "Create 2dsphere index for EA public face areas"
  task create_ea_public_face_area_index: :environment do
    WasteCarriersEngine::EaPublicFaceArea.collection.indexes.create_one(
      { area: "2dsphere" }, name: "area_2dsphere_index"
    )
  end
end
