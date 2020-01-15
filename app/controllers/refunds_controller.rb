# frozen_string_literal: true

class RefundsController < ApplicationController
  include CanFetchRegistrationOrTransientRegistration
  include FinanceDetailsHelper

  before_action :authenticate_user!
  before_action :authorise_user!

  def index
    find_registration(params[:finance_details_id])

    payments = @registration.finance_details.payments.refundable
    @payments = ::PaymentPresenter.create_from_collection(payments, view_context)
  end

  def new
    find_registration(params[:finance_details_id])
    find_payment(params[:order_key])

    @presenter = RefundPresenter.new(@registration.finance_details, @payment)
  end

  def create
    find_registration(params[:finance_details_id])
    find_payment(params[:order_key])

    presenter = RefundPresenter.new(@registration.finance_details, @payment)
    amount_to_refund = presenter.balance_to_refund

    response = ProcessRefundService.run(
      finance_details: @registration.finance_details,
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

    redirect_to finance_details_path(@registration._id)
  end

  private

  def find_payment(order_key)
    @payment = @registration.finance_details.payments.refundable.find_by(order_key: order_key)
  end

  def authorise_user!
    authorize! :refund, WasteCarriersEngine::Registration
  end
end
