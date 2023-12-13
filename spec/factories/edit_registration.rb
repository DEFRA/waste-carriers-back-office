# frozen_string_literal: true

FactoryBot.define do
  factory :edit_registration, class: "EditRegistration" do
    initialize_with { new(reg_identifier: create(:registration, :active).reg_identifier) }

    trait :has_finance_details do
      has_changed_registration_type

      finance_details { association(:finance_details, :has_edit_order, strategy: :build) }
    end

    trait :has_changed_registration_type do
      registration_type { "carrier_dealer" }
    end
  end
end
