# frozen_string_literal: true

class CopyCardsPaymentFormsController < WasteCarriersEngine::FormsController
  include CanPauseCallRecording
  include CanAuthenticateUser

  before_action :check_and_pause_call_recording, only: %i[new]

  def new
    super(CopyCardsPaymentForm, "copy_cards_payment_form")
  end

  def create
    super(CopyCardsPaymentForm, "copy_cards_payment_form")
  end

  private

  def transient_registration_attributes
    params.fetch(:copy_cards_payment_form, {}).permit(:temp_payment_method)
  end
end
