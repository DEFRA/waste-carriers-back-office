# frozen_string_literal: true

FactoryBot.define do
  factory :finance_details, class: WasteCarriersEngine::FinanceDetails do
    trait :positive_balance do
      balance { 100 }
    end

    trait :zero_balance do
      balance { 0 }
    end
  end
end
