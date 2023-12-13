# frozen_string_literal: true

class CopyCardsOrderCompletedFormsController < WasteCarriersEngine::FormsController
  include WasteCarriersEngine::UnsubmittableForm
  include WasteCarriersEngine::CannotGoBackForm

  def new
    return unless super(CopyCardsOrderCompletedForm, "copy_cards_order_completed_form")

    OrderCopyCardsCompletionService.run(@transient_registration)
  end
end
