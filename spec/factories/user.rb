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
  end
end
