# frozen_string_literal: true

class NegativeChargeAdjustFormsController < ResourceFormsController
  include CanSetFlashMessages
  include FinanceDetailsHelper

  before_renew_or_complete :process_charge_adjust

  def new
    super(NegativeChargeAdjustForm, "negative_charge_adjust_form")
  end

  def create
    return unless super(NegativeChargeAdjustForm, "negative_charge_adjust_form")

    flash_success(
      I18n.t(
        "negative_charge_adjust_forms.messages.success",
        amount: display_pence_as_pounds_and_cents(@negative_charge_adjust_form.amount)
      )
    )
  end

  private

  def process_charge_adjust
    ProcessChargeAdjustService.run(
      finance_details: @resource.finance_details,
      form: @negative_charge_adjust_form,
      user: current_user
    )
  end

  def negative_charge_adjust_form_params
    params.fetch(:negative_charge_adjust_form, {}).permit(:amount, :reference, :description)
  end

  def authorize_user
    authorize! :charge_adjust, @resource
  end
end
