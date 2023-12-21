# frozen_string_literal: true

FactoryBot.define do
  factory :communication_record, class: "WasteCarriersEngine::CommunicationRecord" do
    notify_template_id  { "e144cc0c-8903-434f-97a0-c798fcd35beb" }
    sent_at             { "2023-12-21 11:03:42.390943967 +0000" }
    registration { association :registration }

    trait :email do
      notification_type { "email" }
      comms_label       { "Upper tier waste carrier registration email V1" }
      sent_to           { "test@email.com" }
    end

    trait :letter do
      notification_type { "letter" }
      comms_label       { "Upper tier waste carrier registration letter V2" }
      sent_to           { "Jane Doe, 42, Foo Gardens, Baz City, BS1 5AH" }
    end

    trait :text do
      notification_type { "text" }
      comms_label       { "Upper tier waste carrier registration text V3" }
      sent_to           { "0785 0123456" }
    end
  end
end
