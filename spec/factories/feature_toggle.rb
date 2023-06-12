# frozen_string_literal: true

FactoryBot.define do
  factory :feature_toggle, class: "WasteCarriersEngine::FeatureToggle" do
    key { "test-feature" }

    active { false }
  end
end
