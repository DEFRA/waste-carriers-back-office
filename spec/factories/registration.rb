# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: WasteCarriersEngine::Registration do
    tier "UPPER"

    addresses { [build(:address), build(:address)] }

    metaData { build(:metaData) }
  end
end
