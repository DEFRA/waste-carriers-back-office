# frozen_string_literal: true

FactoryBot.define do
  factory :metaData, class: WasteCarriersEngine::MetaData do
    date_registered { Time.current }
    date_activated { Time.current }
    status { :ACTIVE }
    revoked_reason { "reason" }

    trait :active do
      status { :ACTIVE }
    end

    trait :pending do
      date_activated { nil }
      status { :PENDING }
    end
  end
end
