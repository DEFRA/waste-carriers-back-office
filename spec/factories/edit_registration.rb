# frozen_string_literal: true

FactoryBot.define do
  factory :edit_registration, class: "WasteCarriersEngine::EditRegistration" do
    initialize_with { new(reg_identifier: create(:registration, :active).reg_identifier) }
  end
end
