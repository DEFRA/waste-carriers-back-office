# frozen_string_literal: true

FactoryBot.define do
  factory :key_person, class: WasteCarriersEngine::KeyPerson do
    dob { Date.new(2000, 1, 1) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    trait :main do
      person_type { "KEY" }
    end

    trait :relevant do
      person_type { "RELEVANT" }
    end

    trait :requires_conviction_check do
      conviction_search_result { build(:conviction_search_result, :match_result_yes) }
    end

    trait :does_not_require_conviction_check do
      conviction_search_result { build(:conviction_search_result, :match_result_no) }
    end
  end
end
