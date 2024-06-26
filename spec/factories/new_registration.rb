# frozen_string_literal: true

FactoryBot.define do
  factory :new_registration, class: "WasteCarriersEngine::NewRegistration" do
    metaData { association(:metaData, strategy: :build) }

    trait :has_required_data do
      location { "england" }
      declared_convictions { "no" }
      temp_cards { 1 }
      contact_email { "whatever@example.com" }
      first_name { "Jane" }
      last_name { "Doe" }
      metaData { association(:metaData, route: "DIGITAL", strategy: :build) }

      temp_check_your_tier { "unknown" }
      sequence :reg_identifier

      has_addresses
      has_postcode
      has_key_people
      upper

      after(:build, :create) do |new_registration|
        new_registration.prepare_for_payment(:govpay, nil)
      end
    end

    trait :upper do
      tier { WasteCarriersEngine::NewRegistration::UPPER_TIER }
    end

    trait :has_key_people do
      key_people do
        [association(:key_person, :does_not_require_conviction_check, :main, strategy: :build)]
      end
    end

    trait :has_postcode do
      temp_company_postcode { "BS1 5AH" }
      temp_contact_postcode { "BS1 5AH" }
    end

    trait :has_addresses do
      addresses { [association(:address, :registered, strategy: :build), association(:address, :contact, strategy: :build)] }
    end
  end
end
