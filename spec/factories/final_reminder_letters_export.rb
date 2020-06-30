# frozen_string_literal: true

FactoryBot.define do
  factory :final_reminder_letters_export, class: FinalReminderLettersExport do
    created_on { Date.today }
    number_of_letters { 0 }

    trait :printed do
      printed_by { "super_agent@wcr.gov.uk" }
      printed_on { Date.today }
    end
  end
end
