# frozen_string_literal: true

FactoryBot.define do
  factory :payment, class: WasteCarriersEngine::Payment do
    amount { 100 }
  end
end
