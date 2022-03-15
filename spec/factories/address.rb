# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: WasteCarriersEngine::Address do
    house_number { Faker::Number.number(digits: 2) }
    address_line_1 { Faker::Address.street_name }
    address_line_2 { Faker::Address.secondary_address }
    address_line_3 { Faker::Address.community }
    address_line_4 { Faker::Address.community }
    town_city { Faker::Address.city }
    postcode { "FA1 1KE" }
    country { Faker::Address.country }
    uprn { "340116" }

    trait :contact do
      address_type { "POSTAL" }
    end

    trait :registered do
      address_type { "REGISTERED" }
    end
  end
end
