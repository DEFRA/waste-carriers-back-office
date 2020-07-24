# frozen_string_literal: true

FactoryBot.define do
  factory :ad_reminder_letters_export, class: AdReminderLettersExport do
    expires_on { 90.days.from_now }
    number_of_letters { 0 }

    trait :printed do
      printed_by { "super_agent@wcr.gov.uk" }
      printed_on { Date.today }
    end
  end
end
