# frozen_string_literal: true

class RefundsController < ApplicationController
  include CanFetchResource
  include CanSetFlashMessages
  include FinanceDetailsHelper

  prepend_before_action :authorise_user!
  prepend_before_action :authenticate_user!

  before_action :fetch_payment, only: %i[new create]

  def index
    payments = @resource.finance_details.payments.refundable
    @payments = ::PaymentPresenter.create_from_collection(payments, view_context)
  end

  def new
    @presenter = RefundPresenter.new(@resource.finance_details, @payment)
  end

  def create
    presenter = RefundPresenter.new(@resource.finance_details, @payment)
    amount_to_refund = presenter.balance_to_refund

    response = ProcessRefundService.run(
      finance_details: @resource.finance_details,
      payment: @payment,
      user: current_user
    )
    byebug
    if response
      flash_success(
        I18n.t("refunds.flash_messages.successful", amount: display_pence_as_pounds_and_cents(amount_to_refund))
      )
    else
      flash_error(
        I18n.t("refunds.flash_messages.error"), nil
      )
    end

    redirect_to resource_finance_details_path(@resource._id)
  end

  private

  def fetch_payment
    @payment = @resource.finance_details.payments.refundable.where(order_key: params[:order_key]).first
  end

  def authorise_user!
    authorize! :refund, WasteCarriersEngine::Registration
  end
end
