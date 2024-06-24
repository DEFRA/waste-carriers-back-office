# frozen_string_literal: true

class RecordBankTransferRefundFormsController < ResourceFormsController
  include CanSetFlashMessages
  include FinanceDetailsHelper

  def index
    authorize! :record_bank_transfer_refund, @resource

    @payments = ::PaymentPresenter.create_from_collection(payments, view_context)
  end

  def new
    super(RecordBankTransferRefundForm, "record_bank_transfer_refund_form")
  end

  def create
    return unless super(RecordBankTransferRefundForm, "record_bank_transfer_refund_form")

    RecordBankTransferRefundService.run(
      finance_details: @resource.finance_details,
      payment: @payment,
      user: current_user,
    )

    flash_success(
      I18n.t("record_bank_transfer_refund_forms.flash_messages.successful", amount: display_pence_as_pounds_and_cents(@payment.amount))
    )
  end

  private

  def payment
    @payment ||= payments.where(order_key: params[:order_key]).first
  end

  def payments
    @payments ||= @resource.finance_details.payments.where(payment_type: WasteCarriersEngine::Payment::BANKTRANSFER)
  end

  def authorize_user
    authorize! :record_bank_transfer_refund, payment
  end

  def record_bank_transfer_refund_form_params
    params.fetch(:record_bank_transfer_refund_form, {})
  end
end
