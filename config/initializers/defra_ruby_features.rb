# frozen_string_literal: true
require "defra_ruby_features"

DefraRubyFeatures.configure do |configuration|
  # Tell the engine where to find a model to use in order to persist feature toggles data
  configuration.feature_toggle_model_name = "::WasteCarriersEngine::FeatureToggle"
end
