# frozen_string_literal: true

FactoryBot.define do
  factory :order_item, class: "WasteCarriersEngine::OrderItem" do
    currency { "GBP" }

    trait :renewal_item do
      amount { 10_500 }
      description { "renewal of registration" }
      type { "RENEW" }
      quantity { 1 }
    end

    trait :copy_cards_item do
      amount { 500 }
      description { "1 registration card" }
      type { "COPY_CARDS" }
      quantity { 1 }
    end
  end
end
