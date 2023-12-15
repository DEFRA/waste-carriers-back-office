# frozen_string_literal: true

class EditCancelledFormsController < WasteCarriersEngine::FormsController
  include WasteCarriersEngine::UnsubmittableForm
  include WasteCarriersEngine::CannotGoBackForm

  def new
    return unless super(EditCancelledForm, "edit_cancelled_form")

    EditCancellationService.run(edit_registration: @transient_registration)
  end
end
