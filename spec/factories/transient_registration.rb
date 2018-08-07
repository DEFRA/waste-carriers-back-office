# frozen_string_literal: true

FactoryBot.define do
  factory :transient_registration, class: WasteCarriersEngine::TransientRegistration do
    # Create a new registration when initializing
    initialize_with { new(reg_identifier: create(:registration).reg_identifier) }
  end
end
