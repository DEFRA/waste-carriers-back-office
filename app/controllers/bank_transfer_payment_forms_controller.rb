# frozen_string_literal: true

class BankTransferPaymentFormsController < ResourceFormsController
  include FinanceDetailsHelper

  def new
    super(BankTransferPaymentForm, "bank_transfer_payment_form")
  end

  def create
    params[:bank_transfer_payment_form][:updated_by_user] = current_user.email

    return unless super(BankTransferPaymentForm, "bank_transfer_payment_form")

    flash[:success] = I18n.t(
      "payments.messages.success",
      amount: display_pence_as_pounds_and_cents(@bank_transfer_payment_form.amount)
    )
  end

  private

  def bank_transfer_payment_form_params
    params.fetch(:bank_transfer_payment_form, {}).permit(
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
    authorize! :record_bank_transfer_payment, @resource
  end
end
