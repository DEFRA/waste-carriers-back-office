# frozen_string_literal: true

FactoryBot.define do
  factory :admin, class: BackendUsers::Admin do
    sequence :email do |n|
      "admin_user#{n}@example.com"
    end

    password { "Secret123" }
  end
end
