# frozen_string_literal: true

FactoryBot.define do
  factory :user_journey, class: "WasteCarriersEngine::Analytics::UserJourney" do
    journey_type { "NewRegistration" }
    started_route { "DIGITAL" }
    token { SecureRandom.hex(20) }

    transient do
      visited_pages { [] }
    end

    after :create do |user_journey, options|
      options.visited_pages.each do |page|
        user_journey.page_views.create(page:, time: Time.zone.now, route: "DIGITAL")
      end
    end

    trait :registration do
      journey_type { "NewRegistration" }
    end

    trait :renewal do
      journey_type { "RenewingRegistration" }
    end

    trait :started_digital do
      started_route { "DIGITAL" }
    end

    trait :started_assisted_digital do
      started_route { "ASSISTED_DIGITAL" }
    end

    trait :completed_digital do
      completed_route { "DIGITAL" }
      completed_at { Time.zone.now }
    end

    trait :completed_assisted_digital do
      completed_route { "ASSISTED_DIGITAL" }
      completed_at { Time.zone.now }
    end
  end
end
