# frozen_string_literal: true

FactoryBot.define do
  factory :external_user do
    sequence :email do |n|
      "user#{n}@example.com"
    end

    password { "Secret123" }
  end
end
