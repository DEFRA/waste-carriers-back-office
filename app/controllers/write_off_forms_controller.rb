# frozen_string_literal: true

class WriteOffFormsController < ResourceFormsController
  include FinanceDetailsHelper

  before_renew_or_complete :process_write_off

  def new
    super(WriteOffForm, "write_off_form")
  end

  def create
    fetch_resource

    amount_to_write_off = @resource.finance_details.zero_difference_balance

    return unless super(WriteOffForm, "write_off_form")

    flash[:success] = I18n.t(
        "write_off_forms.flash_messages.successful",
        amount: display_pence_as_pounds_and_cents(amount_to_write_off)
      )
  end

  private

  def write_off_form_params
    params.fetch(:write_off_form, {}).permit(:comment)
  end

  def process_write_off
    ProcessWriteOffService.run(
      finance_details: @resource.finance_details,
      user: current_user,
      comment: @write_off_form.comment
    )
  end

  def authorize_user
    return if can?(:write_off_small, @resource.finance_details)
    return if can?(:write_off_large, @resource.finance_details)

    raise CanCan::AccessDenied
  end
end
