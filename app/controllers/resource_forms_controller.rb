# frozen_string_literal: true

# This is a simplified version of WasteCarriersEngine::FormsController, since we don't have to worry about changing the
# workflow state or performing additional validations.
class ResourceFormsController < ApplicationController
  include CanFetchResource

  prepend_before_action :authenticate_user!
  before_action :authorize_if_required, only: %i[new create]

  def new(form_class, form)
    set_up_form(form_class, form)
  end

  def create(form_class, form)
    return false unless set_up_form(form_class, form)

    params = send("#{form}_params")

    # Submit the form by getting the instance variable we just set
    submit_form(instance_variable_get("@#{form}"), params)
  end

  private

  # Expects a form class name (eg ConvictionApprovalForm), a snake_case name for the form (eg conviction_approval_form)
  def set_up_form(form_class, form)
    # Set an instance variable for the form (eg. @conviction_approval_form) using the provided class
    instance_variable_set("@#{form}", form_class.new(@resource))
  end

  def submit_form(form, params)
    if form.submit(params)
      redirect_to resource_finance_details_path(@resource._id)
      true
    else
      render :new
      false
    end
  end

  def authorize_if_required
    send(:authorize_user) if defined?(:authorize_user)
  end
end
