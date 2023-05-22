# frozen_string_literal: true

FactoryBot.define do
  factory :payment, class: "WasteCarriersEngine::Payment" do
    amount { 100 }
    date_received { Time.zone.now }
    order_key { SecureRandom.uuid.split("-").last }

    trait :bank_transfer do
      payment_type { WasteCarriersEngine::Payment::BANKTRANSFER }
    end

    trait :cheque do
      payment_type { WasteCarriersEngine::Payment::CHEQUE }
    end

    trait :cash do
      payment_type { WasteCarriersEngine::Payment::CASH }
    end

    trait :postal_order do
      payment_type { WasteCarriersEngine::Payment::POSTALORDER }
    end

    trait :worldpay do
      payment_type { WasteCarriersEngine::Payment::WORLDPAY }
    end

    trait :worldpay_missed do
      payment_type { WasteCarriersEngine::Payment::WORLDPAY_MISSED }
    end

    trait :missed_card do
      payment_type { WasteCarriersEngine::Payment::MISSED_CARD }
    end

    trait :govpay do
      payment_type { WasteCarriersEngine::Payment::GOVPAY }
      govpay_id { SecureRandom.hex(24) }
    end

    trait :govpay_refund_pending do
      payment_type { WasteCarriersEngine::Payment::REFUND }
      govpay_id { SecureRandom.hex(22) }
      govpay_payment_status { "submitted" }
    end

    trait :govpay_refund_complete do
      payment_type { WasteCarriersEngine::Payment::REFUND }
      govpay_id { SecureRandom.hex(22) }
      govpay_payment_status { "success" }
    end
  end
end
