# frozen_string_literal: true

class PositiveChargeAdjustFormsController < ResourceFormsController
  include CanSetFlashMessages
  include FinanceDetailsHelper

  before_renew_or_complete :process_charge_adjust

  def new
    super(PositiveChargeAdjustForm, "positive_charge_adjust_form")
  end

  def create
    return unless super(PositiveChargeAdjustForm, "positive_charge_adjust_form")

    flash_success(
      I18n.t(
        "positive_charge_adjust_forms.messages.success",
        amount: display_pence_as_pounds_and_cents(@positive_charge_adjust_form.amount)
      )
    )
  end

  private

  def process_charge_adjust
    ProcessChargeAdjustService.run(
      finance_details: @resource.finance_details,
      form: @positive_charge_adjust_form,
      user: current_user
    )
  end

  def positive_charge_adjust_form_params
    params.fetch(:positive_charge_adjust_form, {}).permit(:amount, :reference, :description)
  end

  def authorize_user
    authorize! :charge_adjust, @resource
  end
end
