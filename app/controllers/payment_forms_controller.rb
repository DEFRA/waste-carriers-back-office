# frozen_string_literal: true

class PaymentFormsController < ApplicationController
  include CanFetchResource

  prepend_before_action :authorize_user
  prepend_before_action :authenticate_user!
  before_action :fetch_form

  def new; end

  def create
    if @payment_form.submit(payment_form_params)
      redirect_to payment_path
    else
      render :new
    end
  end

  private

  def payment_form_params
    params.fetch(:payment_form, {}).permit(:payment_type)
  end

  def payment_path
    public_send(
      "new_resource_#{@payment_form.payment_type}_payment_form_path",
      @resource._id
    )
  end

  def fetch_form
    @payment_form = PaymentForm.new
  end

  def authorize_user
    authorize! :view_payments, WasteCarriersEngine::Registration
  end
end
