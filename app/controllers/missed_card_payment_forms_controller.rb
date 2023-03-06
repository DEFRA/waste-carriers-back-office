# frozen_string_literal: true

class MissedCardPaymentFormsController < ResourceFormsController
  include CanSetFlashMessages

  before_renew_or_complete :change_state_if_possible

  def new
    super(MissedCardPaymentForm, "missed_card_payment_form")
  end

  def create
    params[:missed_card_payment_form][:updated_by_user] = current_user.email

    return unless super(MissedCardPaymentForm, "missed_card_payment_form")

    flash_success(
      I18n.t("payments.messages.success", amount: @missed_card_payment_form.amount)
    )
  end

  private

  def missed_card_payment_form_params
    params.fetch(:missed_card_payment_form, {}).permit(
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
    authorize! :record_missed_card_payment, @resource
  end

  def change_state_if_possible
    return unless @resource.is_a?(WasteCarriersEngine::TransientRegistration)

    @resource.next! if @resource.workflow_state == "govpay_form"
  end
end
