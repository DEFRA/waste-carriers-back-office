# frozen_string_literal: true

class WriteOffsController < ApplicationController
  include CanFetchRegistrationOrTransientRegistration
  include FinanceDetailsHelper

  before_action :authenticate_user!
  before_action :fetch_registration
  before_action :authorise_user!

  def new
    @finance_details = @registration.finance_details
    @write_off_form = WriteOffForm.new(@registration)
  end

  def create
    @finance_details = @registration.finance_details
    @write_off_form = WriteOffForm.new(@registration)

    amount_to_write_off = @registration.finance_details.zero_difference_balance

    if @write_off_form.submit(write_off_form_params, current_user)
      flash[:success] = I18n.t(
        "write_off.flash_messages.successful",
        amount: display_pence_as_pounds_and_cents(amount_to_write_off)
      )

      redirect_to finance_details_path(@registration._id)
    else
      render :new
    end
  end

  private

  def fetch_registration
    find_registration(params[:finance_details_id])
  end

  def write_off_form_params
    params.fetch(:write_off_form, {}).permit(:comment)
  end

  def authorise_user!
    return if can?(:write_off_small, @registration.finance_details)
    return if can?(:write_off_large, @registration.finance_details)

    raise CanCan::AccessDenied
  end
end
