# frozen_string_literal: true

FactoryBot.define do
  factory :registration_restore_form do

    initialize_with do
      new(create(:registration, :revoked))
    end
  end
end
