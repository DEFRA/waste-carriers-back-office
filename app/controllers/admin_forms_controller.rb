# frozen_string_literal: true

# This is a simplified version of WasteCarriersEngine::FormsController, since we don't have to worry about changing the
# workflow state or performing additional validations.
class AdminFormsController < ApplicationController
  before_action :authenticate_user!

  def new(form_class, form, reg_identifier, options = {})
    set_up_form(form_class, form, reg_identifier)

    authorize_if_required(options[:authorize_action])
  end

  def create(form_class, form, reg_identifier, options = {})
    return false unless set_up_form(form_class, form, reg_identifier)

    authorize_if_required(options[:authorize_action])

    # Submit the form by getting the instance variable we just set
    submit_form(instance_variable_get("@#{form}"), params[form], options[:success_path])
  end

  private

  # Expects a form class name (eg ConvictionApprovalForm), a snake_case name for the form (eg conviction_approval_form),
  # and the reg_identifier param
  def set_up_form(form_class, form, reg_identifier)
    find_transient_registration(reg_identifier)

    # Set an instance variable for the form (eg. @conviction_approval_form) using the provided class
    instance_variable_set("@#{form}", form_class.new(@transient_registration))
  end

  def submit_form(form, params, success_path)
    if form.submit(params)
      redirect_to success_path || renewing_registration_path(@transient_registration.reg_identifier)
      true
    else
      render :new
      false
    end
  end

  def authorize_if_required(authorize_action)
    public_send(authorize_action, @transient_registration) if authorize_action.present?
  end

  def find_transient_registration(reg_identifier)
    @transient_registration = WasteCarriersEngine::RenewingRegistration.where(reg_identifier: reg_identifier).first
  end

  def renew_if_possible
    renewal_completion_service = WasteCarriersEngine::RenewalCompletionService.new(@transient_registration)
    renewal_completion_service.complete_renewal
  rescue StandardError => e
    Airbrake.notify(e, reg_identifier: @transient_registration.reg_identifier) if defined?(Airbrake)
    Rails.logger.error "Failed to complete renewal for #{@transient_registration.reg_identifier}: " + e.to_s
  end
end
