# frozen_string_literal: true

class CopyCardsOrderCompletedForm < WasteCarriersEngine::BaseForm
  include WasteCarriersEngine::CannotSubmit

  def self.can_navigate_flexibly?
    false
  end
end
