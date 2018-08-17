# frozen_string_literal: true

FactoryBot.define do
  factory :key_person, class: WasteCarriersEngine::KeyPerson do
    trait :requires_conviction_check do
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
    end

    trait :does_not_require_conviction_check do
      conviction_search_result { build(:conviction_search_result, :match_result_no) }
    end
  end
end
