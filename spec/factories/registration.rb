# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: "WasteCarriersEngine::Registration" do
    sequence :reg_identifier do |n|
      "CBDU#{n}"
    end
    business_type { "limitedCompany" }
    company_name { "WasteCo" }
    company_no { "09360070" } # We need to use a valid company number
    contact_email { "whatever@example.com" }
    first_name { "Jane" }
    last_name { "Doe" }
    registration_type { "carrier_broker_dealer" }
    phone_number { "03708 506506" }
    tier { "UPPER" }

    finance_details { association(:finance_details, :has_paid_order_and_payment, strategy: :build) }

    addresses { [association(:address, :registered, strategy: :build), association(:address, :contact, strategy: :build)] }
    key_people { [association(:key_person, :does_not_require_conviction_check, :main, strategy: :build)] }

    metaData { association(:metaData, strategy: :build) }

    trait :simple_address do
      addresses { [association(:simple_address, strategy: :build)] }
    end

    trait :ad_registration do
      contact_email { nil }
    end

    trait :cancelled do
      metaData { association(:metaData, :cancelled, strategy: :build) }
    end

    trait :overpaid do
      finance_details { association(:finance_details, :has_overpaid_order_and_payment, strategy: :build) }
    end

    trait :pending do
      metaData { association(:metaData, :pending, strategy: :build) }
    end

    trait :has_unpaid_order do
      finance_details { association(:finance_details, :has_unpaid_order, strategy: :build) }
    end

    trait :has_copy_cards_order do
      finance_details { association(:finance_details, :has_copy_cards_order, strategy: :build) }
    end

    trait :active do
      metaData { association(:metaData, :active, strategy: :build) }
    end

    trait :inactive do
      metaData { association(:metaData, :cancelled, strategy: :build) }
    end

    trait :ceased do
      metaData { association(:metaData, :ceased, strategy: :build) }
    end

    trait :expired do
      metaData { association(:metaData, :expired, strategy: :build) }
    end

    trait :revoked do
      metaData { association(:metaData, :revoked, strategy: :build) }
    end

    trait :restored do
      metaData { association(:metaData, :active, restored_reason: "a reason", restored_by: "whatever@example.com", strategy: :build) }
    end

    trait :registered_15_months_ago do
      metaData { association(:metaData, :active, dateRegistered: 15.months.ago, strategy: :build) }
    end

    trait :has_orders_and_payments do
      finance_details { association(:finance_details, :has_paid_order_and_payment, strategy: :build) }
    end

    trait :expires_soon do
      metaData { association(:metaData, :active, strategy: :build) }
      expires_on { 2.months.from_now }
    end

    trait :expires_tomorrow do
      metaData { association(:metaData, :active, strategy: :build) }
      expires_on { 1.day.from_now }
    end

    trait :pending_payment do
      finance_details { association(:finance_details, :positive_balance, strategy: :build) }
    end

    trait :no_pending_payment do
      finance_details { association(:finance_details, :zero_balance, strategy: :build) }
    end

    trait :requires_conviction_check do
      pending

      key_people { [association(:key_person, :requires_conviction_check, strategy: :build)] }
      conviction_search_result { association(:conviction_search_result, :match_result_yes, strategy: :build) }
      conviction_sign_offs { [association(:conviction_sign_off, strategy: :build)] }
    end

    trait :has_flagged_conviction_check do
      pending

      key_people { [association(:key_person, :requires_conviction_check, strategy: :build)] }
      conviction_search_result { association(:conviction_search_result, :match_result_yes, strategy: :build) }
      conviction_sign_offs { [association(:conviction_sign_off, :checks_in_progress, strategy: :build)] }
    end

    trait :has_approved_conviction_check do
      key_people { [association(:key_person, :requires_conviction_check, strategy: :build)] }
      conviction_search_result { association(:conviction_search_result, :match_result_yes, strategy: :build) }
      conviction_sign_offs { [association(:conviction_sign_off, :approved, strategy: :build)] }
    end

    trait :has_rejected_conviction_check do
      key_people { [association(:key_person, :requires_conviction_check, strategy: :build)] }
      conviction_search_result { association(:conviction_search_result, :match_result_yes, strategy: :build) }
      conviction_sign_offs { [association(:conviction_sign_off, :rejected, strategy: :build)] }
    end
  end
end
