# frozen_string_literal: true

class ChargeAdjustFormsController < ResourceFormsController
  include CanFetchResource

  def new
    super(ChargeAdjustForm, "charge_adjust_form")
  end

  def create
    super(ChargeAdjustForm, "charge_adjust_form")
  end

  private

  def charge_adjust_form_params
    params.fetch(:charge_adjust_form, {}).permit(:charge_type)
  end

  def renew_if_possible_and_redirect
    redirect_to public_send("new_resource_#{@charge_adjust_form.charge_type}_charge_adjust_form_path")
  end

  def authorize_user
    authorize! :charge_adjust, @resource
  end
end
