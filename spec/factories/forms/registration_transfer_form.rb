# frozen_string_literal: true

FactoryBot.define do
  factory :registration_transfer_form do
    email { "foobar@example.com" }
    confirm_email { "foobar@example.com" }

    initialize_with do
      new(create(:registration))
    end
  end
end
