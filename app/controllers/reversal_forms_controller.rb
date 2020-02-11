# frozen_string_literal: true

class ReversalFormsController < ResourceFormsController
  include FinanceDetailsHelper

  def index
    authorize! :view_payments, @resource

    payments = @resource.finance_details.payments.reversible
    @payments = ::PaymentPresenter.create_from_collection(payments, view_context)
  end

  def new
    super(ReversalForm,
          "reversal_form")
  end

  def create
    super(ReversalForm,
          "reversal_form")
  end

  private

  def reversal_form_params
    params.fetch(:reversal_form, {}).permit(:reason)
  end

  def submit_form(form, params)
    if form.submit(params)
      ProcessReversalService.run(
        finance_details: @resource.finance_details,
        payment: @payment,
        user: current_user,
        reason: form.reason
      )

      flash[:success] = I18n.t(
        "reversal_forms.flash_messages.successful",
        amount: display_pence_as_pounds_and_cents(@payment.amount)
      )

      redirect_to resource_finance_details_path(@resource._id)
    else
      render :new, order_key: params[:order_key]
    end
  end

  def payment
    @payment ||= @resource.finance_details.payments.reversible.where(order_key: params[:order_key]).first
  end

  def authorize_user
    authorize! :reverse, payment
  end
end
