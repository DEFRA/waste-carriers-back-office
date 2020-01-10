# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end

    password { "Secret123" }

    role { "agency" }

    trait :inactive do
      active { false }
    end

    trait :agency do
      role { "agency" }
    end

    trait :agency_with_refund do
      role { "agency_with_refund" }
    end

    trait :finance do
      role { "finance" }
    end

    trait :finance_admin do
      role { "finance_admin" }
    end

    trait :agency_super do
      role { "agency_super" }
    end

    trait :finance_super do
      role { "finance_super" }
    end
  end
end
