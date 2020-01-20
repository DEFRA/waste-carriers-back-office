# frozen_string_literal: true

class RefundsController < ApplicationController
  include CanFetchResource
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

    if response
      flash[:success] = I18n.t(
        "refunds.flash_messages.successful",
        amount: display_pence_as_pounds_and_cents(amount_to_refund)
      )
    else
      flash[:error] = I18n.t("refunds.flash_messages.error")
    end

    redirect_to resource_finance_details_path(@resource._id)
  end

  private

  def fetch_payment
    @payment = @resource.finance_details.payments.refundable.find_by(order_key: params[:order_key])
  end

  def authorise_user!
    authorize! :refund, WasteCarriersEngine::Registration
  end
end
