# frozen_string_literal: true

FactoryBot.define do
  factory :transient_registration, class: WasteCarriersEngine::TransientRegistration do
    sequence :reg_identifier do |n|
      "CBDU#{n}"
    end
  end
end
