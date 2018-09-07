# frozen_string_literal: true

FactoryBot.define do
  factory :transient_registration, class: WasteCarriersEngine::TransientRegistration do
    location { "england" }
    temp_cards { 1 }

    addresses { [build(:address, :registered), build(:address, :contact)] }

    # Create a new registration when initializing
    initialize_with { new(reg_identifier: create(:registration, :expires_soon).reg_identifier) }

    trait :ready_to_renew do
      declared_convictions { "no" }
      workflow_state { "renewal_received_form" }

      conviction_search_result { build(:conviction_search_result, :match_result_no) }
      finance_details { build(:finance_details, :zero_balance) }
      key_people { [build(:key_person, :does_not_require_conviction_check)] }

      initialize_with { new(reg_identifier: create(:registration, :expires_soon).reg_identifier) }
    end

    trait :pending_payment do
      workflow_state { "renewal_received_form" }
      finance_details { build(:finance_details, :positive_balance) }
    end

    trait :no_pending_payment do
      workflow_state { "renewal_received_form" }
      finance_details { build(:finance_details, :zero_balance) }
    end

    trait :requires_conviction_check do
      workflow_state { "renewal_received_form" }
      key_people { [build(:key_person, :requires_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
      conviction_sign_offs { [build(:conviction_sign_off)] }
    end

    trait :does_not_require_conviction_check do
      workflow_state { "renewal_received_form" }
      key_people { [build(:key_person, :does_not_require_conviction_check)] }
      conviction_search_result { build(:conviction_search_result, :match_result_no) }
    end

    trait :has_finance_details do
      temp_cards { 0 }
      after(:build, :create) do |transient_registration|
        WasteCarriersEngine::FinanceDetails.new_finance_details(transient_registration, :bank_transfer, build(:user))
      end
    end
  end
end
