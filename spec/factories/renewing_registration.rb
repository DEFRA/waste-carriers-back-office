# frozen_string_literal: true

FactoryBot.define do
  factory :renewing_registration, class: WasteCarriersEngine::RenewingRegistration do
    location { "england" }
    temp_cards { 1 }

    addresses { [build(:address, :registered), build(:address, :contact)] }

    finance_details { build(:finance_details, :has_paid_order_and_payment) }

    # Create a new registration when initializing
    initialize_with { new(reg_identifier: create(:registration, :expires_soon).reg_identifier) }

    trait :overpaid do
      finance_details { build(:finance_details, :has_overpaid_order_and_payment) }
    end

    trait :submitted do
      workflow_state { "renewal_received_form" }
    end

    trait :ready_to_renew do
      declared_convictions { "no" }
      submitted

      conviction_search_result { build(:conviction_search_result, :match_result_no) }
      finance_details { build(:finance_details, :zero_balance) }
      key_people { [build(:key_person, :does_not_require_conviction_check)] }

      initialize_with { new(reg_identifier: create(:registration, :expires_soon).reg_identifier) }
    end

    trait :pending_payment do
      submitted

      finance_details { build(:finance_details, :has_unpaid_order) }
    end

    trait :no_pending_payment do
      submitted

      finance_details { build(:finance_details, :zero_balance) }
    end

    trait :requires_conviction_check do
      submitted

      key_people { [build(:key_person, :requires_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
      conviction_sign_offs { [build(:conviction_sign_off)] }
    end

    trait :does_not_require_conviction_check do
      submitted

      key_people { [build(:key_person, :does_not_require_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_no) }
    end

    trait :has_flagged_conviction_check do
      submitted

      key_people { [build(:key_person, :requires_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
      conviction_sign_offs { [build(:conviction_sign_off, :checks_in_progress)] }
    end

    trait :has_approved_conviction_check do
      submitted

      key_people { [build(:key_person, :requires_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
      conviction_sign_offs { [build(:conviction_sign_off, :approved)] }
    end

    trait :has_rejected_conviction_check do
      submitted

      key_people { [build(:key_person, :requires_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
      conviction_sign_offs { [build(:conviction_sign_off, :rejected)] }
    end

    trait :has_finance_details do
      temp_cards { 0 }
      after(:build, :create) do |transient_registration|
        transient_registration.prepare_for_payment(:bank_transfer, build(:user))
      end
    end
  end
end
