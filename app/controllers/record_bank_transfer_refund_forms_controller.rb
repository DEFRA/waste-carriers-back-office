# frozen_string_literal: true

class RecordBankTransferRefundFormsController < ResourceFormsController
  include CanSetFlashMessages
  include FinanceDetailsHelper

  def index
    authorize! :record_bank_transfer_refund, @resource
    @payments = ::PaymentPresenter.create_from_collection(eligible_payments, view_context)
  end

  def new
    @presenter = RefundPresenter.new(@resource.finance_details, payment)
  end

  def create
    presenter = RefundPresenter.new(@resource.finance_details, payment)
    amount_to_refund = presenter.balance_to_refund
    response = RecordBankTransferRefundService.run(
      finance_details: @resource.finance_details,
      payment: payment,
      user: current_user
    )
    if response
      flash_success(
        I18n.t("record_bank_transfer_refund_forms.flash_messages.successful",
               amount: display_pence_as_pounds_and_cents(amount_to_refund))
      )
    else
      flash_error(
        I18n.t("record_bank_transfer_refund_forms.flash_messages.error",
               type: payment.payment_type.titleize), nil
      )
    end
    redirect_to resource_finance_details_path(@resource._id)
  end

  private

  def payment
    @payment ||= eligible_payments.where(order_key: params[:order_key]).first
  end

  def eligible_payments
    @eligible_payments ||= @resource.finance_details.payments
                                    .where(payment_type: WasteCarriersEngine::Payment::BANKTRANSFER)
  end

  def authorize_user
    authorize! :record_bank_transfer_refund, payment
  end
end
