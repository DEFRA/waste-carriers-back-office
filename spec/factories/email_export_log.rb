# frozen_string_literal: true

FactoryBot.define do
  factory :email_export_log do
    transient do
      export_time { 1.day.ago }
    end
    initialize_with do
      new("Email_batch_1_100_#{export_time.strftime('%Y-%m-%d %H:%M')}", export_time)
    end
  end
end
