# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: WasteCarriersEngine::Address do
    house_number { Faker::Number.number(digits: 2) }
    address_line1 { Faker::Address.street_name }
    address_line2 { Faker::Address.secondary_address }
    address_line3 { Faker::Address.community }
    address_line4 { Faker::Address.community }
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

  # This is to support legacy tests (notify letters) that broke
  # when the address factory was changed.
  factory :simple_address, class: WasteCarriersEngine::Address do
    house_number { "42" }
    address_line1 { "Foo Gardens" }
    town_city { "Baz City" }
    postcode { "FA1 1KE" }
    address_type { "POSTAL" }
  end
end
