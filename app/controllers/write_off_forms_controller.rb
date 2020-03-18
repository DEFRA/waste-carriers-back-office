# frozen_string_literal: true

# TODO: Refactor to inherit from ResourceFormController
class WriteOffFormsController < ApplicationController
  include CanFetchResource
  include FinanceDetailsHelper
  include CanRenewIfPossible
  include CanCompleteIfPossible

  prepend_before_action :authenticate_user!

  before_action :authorise_user!
  before_action :fetch_finance_details
  before_action :fetch_write_off_form

  def new; end

  def create
    amount_to_write_off = @resource.finance_details.zero_difference_balance

    if @write_off_form.submit(write_off_form_params, current_user)
      flash[:success] = I18n.t(
        "write_off_forms.flash_messages.successful",
        amount: display_pence_as_pounds_and_cents(amount_to_write_off)
      )

      if renew_if_possible
        redirect_to resource_finance_details_path(@resource.registration._id)
      else
        complete_if_possible

        redirect_to resource_finance_details_path(@resource._id)
      end
    else
      render :new
    end
  end

  private

  def write_off_form_params
    params.fetch(:write_off_form, {}).permit(:comment)
  end

  def fetch_finance_details
    @finance_details = @resource.finance_details
  end

  def fetch_write_off_form
    @write_off_form = WriteOffForm.new(@resource)
  end

  def authorise_user!
    return if can?(:write_off_small, @resource.finance_details)
    return if can?(:write_off_large, @resource.finance_details)

    raise CanCan::AccessDenied
  end
end
