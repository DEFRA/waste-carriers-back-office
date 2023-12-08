# frozen_string_literal: true

class CopyCardsOrderCompletedFormsController < WasteCarriersEngine::FormsController
  include WasteCarriersEngine::UnsubmittableForm
  include WasteCarriersEngine::CannotGoBackForm
  include CanResumeCallRecording
  include CanAuthenticateUser

  before_action :check_and_resume_call_recording, only: %i[new]

  def new
    return unless super(CopyCardsOrderCompletedForm, "copy_cards_order_completed_form")

    OrderCopyCardsCompletionService.run(@transient_registration)
  end
end
