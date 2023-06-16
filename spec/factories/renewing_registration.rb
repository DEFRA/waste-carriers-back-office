# frozen_string_literal: true

FactoryBot.define do
  factory :renewing_registration, class: "WasteCarriersEngine::RenewingRegistration" do
    contact_email { "whatever@example.com" }
    first_name { "Jane" }
    last_name { "Doe" }
    location { "england" }
    temp_cards { 1 }
    phone_number { "03708 506506" }

    addresses { [association(:address, :registered, strategy: :build), association(:address, :contact, strategy: :build)] }

    finance_details { association(:finance_details, :has_paid_order_and_payment, strategy: :build) }

    initialize_with { new(reg_identifier: create(:registration, :expires_soon).reg_identifier) }

    trait :overpaid do
      finance_details { association(:finance_details, :has_overpaid_order_and_payment, strategy: :build) }
    end

    trait :overpaid_govpay do
      finance_details { association(:finance_details, :has_overpaid_order_and_payment_govpay, strategy: :build) }
    end

    trait :submitted do
      workflow_state { "renewal_received_pending_payment_form" }
    end

    trait :ready_to_renew do
      declared_convictions { "no" }
      submitted

      conviction_search_result { association(:conviction_search_result, :match_result_no, strategy: :build) }
      finance_details { association(:finance_details, :zero_balance, strategy: :build) }
      key_people { [association(:key_person, :does_not_require_conviction_check, strategy: :build)] }

      initialize_with { new(reg_identifier: create(:registration, :expires_soon).reg_identifier) }
    end

    trait :pending_payment do
      submitted

      finance_details { association(:finance_details, :has_unpaid_order, strategy: :build) }
    end

    trait :no_pending_payment do
      submitted

      finance_details { association(:finance_details, :zero_balance, strategy: :build) }
    end

    trait :requires_conviction_check do
      submitted

      key_people { [association(:key_person, :requires_conviction_check, strategy: :build)] }
      conviction_search_result { association(:conviction_search_result, :match_result_yes, strategy: :build) }
      conviction_sign_offs { [association(:conviction_sign_off, strategy: :build)] }
    end

    trait :does_not_require_conviction_check do
      submitted

      key_people { [association(:key_person, :does_not_require_conviction_check, strategy: :build)] }
      conviction_search_result { association(:conviction_search_result, :match_result_no, strategy: :build) }
    end

    trait :has_flagged_conviction_check do
      submitted

      key_people { [association(:key_person, :requires_conviction_check, strategy: :build)] }
      conviction_search_result { association(:conviction_search_result, :match_result_yes, strategy: :build) }
      conviction_sign_offs { [association(:conviction_sign_off, :checks_in_progress, strategy: :build)] }
    end

    trait :has_approved_conviction_check do
      submitted

      key_people { [association(:key_person, :requires_conviction_check, strategy: :build)] }
      conviction_search_result { association(:conviction_search_result, :match_result_yes, strategy: :build) }
      conviction_sign_offs { [association(:conviction_sign_off, :approved, strategy: :build)] }
    end

    trait :has_rejected_conviction_check do
      submitted

      key_people { [association(:key_person, :requires_conviction_check, strategy: :build)] }
      conviction_search_result { association(:conviction_search_result, :match_result_yes, strategy: :build) }
      conviction_sign_offs { [association(:conviction_sign_off, :rejected, strategy: :build)] }
    end

    trait :has_finance_details do
      temp_cards { 0 }
      after(:build, :create) do |transient_registration|
        transient_registration.prepare_for_payment(:bank_transfer, build(:user))
      end
    end
  end
end
