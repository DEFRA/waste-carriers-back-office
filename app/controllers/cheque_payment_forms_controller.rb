# frozen_string_literal: true

class ChequePaymentFormsController < ResourceFormsController
  include FinanceDetailsHelper

  def new
    super(ChequePaymentForm, "cheque_payment_form")
  end

  def create
    params[:cheque_payment_form][:updated_by_user] = current_user.email

    return unless super(ChequePaymentForm, "cheque_payment_form")

    flash[:success] = I18n.t(
      "payments.messages.success",
      amount: display_pence_as_pounds_and_cents(@cheque_payment_form.amount)
    )
  end

  private

  def cheque_payment_form_params
    params.fetch(:cheque_payment_form, {}).permit(
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
    authorize! :record_cheque_payment, @resource
  end
end
