# frozen_string_literal: true

FactoryBot.define do
  factory :agency_user, class: BackendUsers::AgencyUser do
    sequence :email do |n|
      "agency_user#{n}@example.com"
    end

    password { "Secret123" }
  end
end
