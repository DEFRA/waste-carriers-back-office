# frozen_string_literal: true

FactoryBot.define do
  factory :external_user do
    sequence :email do |n|
      "user#{n}@example.com"
    end

    password { "Secretofth3w0rld" }
  end
end
