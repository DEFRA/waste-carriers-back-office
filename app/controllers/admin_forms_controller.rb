# frozen_string_literal: true

# This is a simplified version of WasteCarriersEngine::FormsController, since we don't have to worry about changing the
# workflow state or performing additional validations.
class AdminFormsController < ApplicationController
  before_action :authenticate_user!

  def new(form_class, form, reg_identifier, authorize_action = nil)
    set_up_form(form_class, form, reg_identifier)

    public_send(authorize_action, @transient_registration) if authorize_action.present?
  end

  def create(form_class, form, reg_identifier, authorize_action = nil)
    return false unless set_up_form(form_class, form, reg_identifier)

    public_send(authorize_action, @transient_registration) if authorize_action.present?

    # Submit the form by getting the instance variable we just set
    submit_form(instance_variable_get("@#{form}"), params[form])
  end

  private

  # Expects a form class name (eg ConvictionApprovalForm), a snake_case name for the form (eg conviction_approval_form),
  # and the reg_identifier param
  def set_up_form(form_class, form, reg_identifier)
    find_transient_registration(reg_identifier)

    # Set an instance variable for the form (eg. @conviction_approval_form) using the provided class
    instance_variable_set("@#{form}", form_class.new(@transient_registration))
  end

  def submit_form(form, params)
    if form.submit(params)
      redirect_to transient_registration_path(@transient_registration.reg_identifier)
      true
    else
      render :new
      false
    end
  end

  def find_transient_registration(reg_identifier)
    @transient_registration = WasteCarriersEngine::TransientRegistration.where(reg_identifier: reg_identifier).first
  end

  def renew_if_possible
    renewability_check_service = RenewabilityCheckService.new(@transient_registration)
    renewability_check_service.complete_renewal
  end
end
