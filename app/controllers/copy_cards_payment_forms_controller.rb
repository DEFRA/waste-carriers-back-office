# frozen_string_literal: true

class CopyCardsPaymentFormsController < BackOfficeFormsController
  include CanPauseCallRecording

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

  def authorize_user
    authorize! :order_copy_cards, WasteCarriersEngine::Registration
  end
end
