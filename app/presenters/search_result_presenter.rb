# frozen_string_literal: true

class SearchResultPresenter < WasteCarriersEngine::BasePresenter
  include WasteCarriersEngine::CanPresentEntityDisplayName

  def initialize(model)
    @original_model = model
    super(model)
  end

  # ActionLinksHelper uses `is_a?(model-klass)` to make page display decisions.
  # Here we enable that method to be called on the model that was passed to this
  # class so we can continue to support that behaviour
  def is_a?(klass)
    @original_model.is_a?(klass)
  end
end
