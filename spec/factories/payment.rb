# frozen_string_literal: true

FactoryBot.define do
  factory :payment, class: WasteCarriersEngine::Payment do
    amount { 100 }
    date_received { Time.now }
    order_key { SecureRandom.uuid.split("-").last }

    trait :bank_transfer do
      payment_type { WasteCarriersEngine::Payment::BANKTRANSFER }
    end

    trait :cheque do
      payment_type { "CHEQUE" }
    end

    trait :cash do
      payment_type { "CASH" }
    end

    trait :postal_order do
      payment_type { "POSTALORDER" }
    end

    trait :bank_transfer do
      payment_type { "BANKTRANSFER" }
    end

    trait :worldpay do
      payment_type { "WORLDPAY" }
    end

    trait :worldpay_missed do
      payment_type { "WORLDPAY_MISSED" }
    end
  end
end
