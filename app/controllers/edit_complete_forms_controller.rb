# frozen_string_literal: true

class EditCompleteFormsController < WasteCarriersEngine::FormsController
  include WasteCarriersEngine::UnsubmittableForm
  include WasteCarriersEngine::CannotGoBackForm

  def new
    return unless super(EditCompleteForm, "edit_complete_form")

    EditCompletionService.run(edit_registration: @transient_registration)
  end
end
