# frozen_string_literal: true

module Constraint
  class FeatureToggleConstraint
    def initialize(feature)
      @feature = feature
    end

    def matches?(_req)
      WasteCarriersEngine::FeatureToggle.active?(@feature)
    end
  end
end
