# frozen_string_literal: true

class ChargeAdjustStartFormsController < ResourceFormsController
  def new
    super(ChargeAdjustStartForm,
          "charge_adjust_start_form")
  end

  def create
    super(ChargeAdjustStartForm,
          "charge_adjust_start_form")
  end

  private

  def charge_adjust_start_form_params
    params.fetch(:charge_adjust_start_form, {}).permit(:charge_type)
  end

  def submit_form(form, params)
    if form.submit(params)
      redirect_to public_send("new_resource_#{@charge_adjust_start_form.charge_type}_charge_adjust_form_path")
    else
      render :new
    end
  end

  def authorize_user
    raise CanCan::AccessDenied unless can?(:charge_adjust, @resource)
  end
end
