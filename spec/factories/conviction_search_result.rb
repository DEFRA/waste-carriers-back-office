# frozen_string_literal: true

FactoryBot.define do
  factory :conviction_search_result, class: WasteCarriersEngine::ConvictionSearchResult do
    trait :match_result_yes do
      match_result { "YES" }
    end

    trait :match_result_no do
      match_result { "NO" }
    end

    trait :match_result_unknown do
      match_result { "UNKNOWN" }
    end
  end
end
