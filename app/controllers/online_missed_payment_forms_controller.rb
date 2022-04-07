# frozen_string_literal: true

class OnlineMissedPaymentFormsController < ResourceFormsController
  include CanSetFlashMessages

  before_renew_or_complete :change_state_if_possible

  def new
    super(OnlineMissedPaymentForm, "online_missed_payment_form")
  end

  def create
    params[:online_missed_payment_form][:updated_by_user] = current_user.email

    return unless super(OnlineMissedPaymentForm, "online_missed_payment_form")

    flash_success(
      I18n.t("payments.messages.success", amount: @online_missed_payment_form.amount)
    )
  end

  private

  def online_missed_payment_form_params
    params.fetch(:online_missed_payment_form, {}).permit(
      :amount,
      :comment,
      :registration_reference,
      :date_received_day,
      :date_received_month,
      :date_received_year,
      :updated_by_user
    )
  end

  def authorize_user
    authorize! :record_online_missed_payment, @resource
  end

  def change_state_if_possible
    return unless @resource.is_a?(WasteCarriersEngine::TransientRegistration)

    @resource.next! if @resource.workflow_state == "worldpay_form"
  end
end
