# frozen_string_literal: true

FactoryBot.define do
  factory :order_item_log, class: WasteCarriersEngine::OrderItemLog do
    order_item_id { SecureRandom.hex(12) }
    order_id { SecureRandom.hex(12) }
    registration_id { SecureRandom.hex(12) }
    activated_at { Time.now }
    type { "NEW" }
    quantity { Faker::Number.between(from: 1, to: 5) }
    exported { false }
  end
end
