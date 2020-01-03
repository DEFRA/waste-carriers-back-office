# frozen_string_literal: true

class RefundsController < ApplicationController
  include CanFetchRegistrationOrTransientRegistration

  before_action :authenticate_user!

  def index
    find_registration(params[:finance_details_id])

    # @finance_details = @registration.finance_details
    @payments = @registration.finance_details.payments.refundable
  end

  def new
    find_registration(params[:id])
    find_payment(params[:order_key])
  end

  def create
    find_registration(params[:id])
    find_payment(params[:order_key])

    CreateRefundService.run(@payment)

    flash[:message] = "#{@payment.balance} refunded successfully"

    redirect_to finance_details_path(@registration._id)
  end

  private

  def find_payment(order_key)
    @payment = @registration.finance_details.payments.refundable.find_by(order_key: order_key)
  end
end
