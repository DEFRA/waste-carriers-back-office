# frozen_string_literal: true

FactoryBot.define do
  factory :conviction_sign_off, class: WasteCarriersEngine::ConvictionSignOff do
    confirmed { "no" }

    trait :confirmed do
      confirmed { "yes" }
    end
  end
end
