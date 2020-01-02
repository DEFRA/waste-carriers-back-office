# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: WasteCarriersEngine::Order do
    trait :has_required_data do
      order_items do
        [WasteCarriersEngine::OrderItem.new_renewal_item,
         WasteCarriersEngine::OrderItem.new_copy_cards_item(1)]
      end
      payment_method { "card" }
      total_amount { order_items.sum { |item| item[:amount] } }
      date_created { Time.now }
    end
  end
end
