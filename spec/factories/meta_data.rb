# frozen_string_literal: true

FactoryBot.define do
  factory :metaData, class: "WasteCarriersEngine::MetaData" do
    date_registered { Time.current }
    date_activated { Time.current }
    status { :ACTIVE }
    revoked_reason { "reason" }

    trait :active do
      status { :ACTIVE }
    end

    trait :cancelled do
      status { :INACTIVE }
    end

    trait :ceased do
      status { :INACTIVE }
    end

    trait :expired do
      status { :EXPIRED }
    end

    trait :pending do
      date_activated { nil }
      status { :PENDING }
    end

    trait :revoked do
      status { :REVOKED }
    end
  end
end
