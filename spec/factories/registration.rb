# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: WasteCarriersEngine::Registration do
    sequence :reg_identifier do |n|
      "CBDU#{n}"
    end
    account_email { "whatever@example.com" }
    business_type { "limitedCompany" }
    company_name { "WasteCo" }
    company_no { "09360070" } # We need to use a valid company number
    contact_email { "whatever@example.com" }
    first_name { "Jane" }
    last_name { "Doe" }
    registration_type { "carrier_broker_dealer" }
    phone_number { "03708 506506" }
    tier { "UPPER" }

    finance_details { build(:finance_details, :has_paid_order_and_payment) }

    addresses { [build(:address, :registered), build(:address, :contact)] }
    key_people { [build(:key_person, :does_not_require_conviction_check)] }

    metaData { build(:metaData) }

    trait :overpaid do
      finance_details { build(:finance_details, :has_overpaid_order_and_payment) }
    end

    trait :pending do
      metaData { build(:metaData, :pending) }
    end

    trait :has_unpaid_order do
      finance_details { build(:finance_details, :has_unpaid_order) }
    end

    trait :active do
      metaData { build(:metaData, :active) }
    end

    trait :expired do
      metaData { build(:metaData, :expired) }
    end

    trait :has_orders_and_payments do
      finance_details { build(:finance_details, :has_paid_order_and_payment) }
    end

    trait :expires_soon do
      metaData { build(:metaData, :active) }
      expires_on { 2.months.from_now }
    end

    trait :pending_payment do
      finance_details { build(:finance_details, :positive_balance) }
    end

    trait :no_pending_payment do
      finance_details { build(:finance_details, :zero_balance) }
    end

    trait :requires_conviction_check do
      pending

      key_people { [build(:key_person, :requires_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
      conviction_sign_offs { [build(:conviction_sign_off)] }
    end

    trait :has_flagged_conviction_check do
      pending

      key_people { [build(:key_person, :requires_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
      conviction_sign_offs { [build(:conviction_sign_off, :checks_in_progress)] }
    end

    trait :has_approved_conviction_check do
      key_people { [build(:key_person, :requires_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
      conviction_sign_offs { [build(:conviction_sign_off, :approved)] }
    end

    trait :has_rejected_conviction_check do
      key_people { [build(:key_person, :requires_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
      conviction_sign_offs { [build(:conviction_sign_off, :rejected)] }
    end
  end
end
