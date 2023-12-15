# frozen_string_literal: true

class EditPaymentSummaryFormsController < WasteCarriersEngine::FormsController
  include CanPauseCallRecording
  include CanAuthenticateUser

  before_action :check_and_pause_call_recording, only: %i[new]

  def new
    return unless super(EditPaymentSummaryForm, "edit_payment_summary_form")

    set_up_finance_details
  end

  def create
    super(EditPaymentSummaryForm, "edit_payment_summary_form")
  end

  private

  def transient_registration_attributes
    params.fetch(:edit_payment_summary_form, {}).permit(:temp_payment_method)
  end

  def fetch_presenters
    @order_and_total_presenter = OrderAndTotalPresenter.new(@edit_payment_summary_form, view_context)
  end

  def set_up_finance_details
    return if @transient_registration.finance_details.present?

    @transient_registration.prepare_for_payment(:unknown, current_user)
  end
end
