# frozen_string_literal: true

FactoryBot.define do
  factory :card_orders_export_log do
    transient do
      end_time { Faker::Date.in_date_period.midnight }
    end
    initialize_with do
      new(
        end_time - 1.week,
        end_time,
        Faker::File.file_name,
        end_time + rand(1..2_000).minutes
      )
    end
  end
end
