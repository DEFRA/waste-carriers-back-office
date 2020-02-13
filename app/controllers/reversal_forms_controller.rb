# frozen_string_literal: true

class ReversalFormsController < ResourceFormsController
  include FinanceDetailsHelper

  def index
    payments = @resource.finance_details.payments.reversible
    @payments = ::PaymentPresenter.create_from_collection(payments, view_context)
  end

  def new
    super(ReversalForm, "reversal_form")
  end

  def create
    return unless super(ReversalForm, "reversal_form")

    ProcessReversalService.run(
      finance_details: @resource.finance_details,
      payment: @payment,
      user: current_user,
      reason: @reversal_form.reason
    )

    flash[:success] = I18n.t(
      "reversal_forms.flash_messages.successful",
      amount: display_pence_as_pounds_and_cents(@payment.amount)
    )
  end

  private

  def reversal_form_params
    params.fetch(:reversal_form, {}).permit(:reason)
  end

  def payment
    @payment ||= @resource.finance_details.payments.reversible.where(order_key: params[:order_key]).first
  end

  def authorize_user
    authorize! :reverse, payment
  end
end
