# frozen_string_literal: true

FactoryBot.define do
  factory :metaData, class: WasteCarriersEngine::MetaData do
    date_registered { Time.current }
    status { :ACTIVE }
    revoked_reason { "reason" }
  end
end
