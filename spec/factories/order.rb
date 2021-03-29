# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: WasteCarriersEngine::Order do
    trait :has_required_data do
      order_items do
        [build(:order_item, :renewal_item),
         build(:order_item, :copy_cards_item)]
      end
      payment_method { "card" }
      total_amount { order_items.sum { |item| item[:amount] } }
      date_created { Time.now }
    end
  end
end
