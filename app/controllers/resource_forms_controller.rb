# frozen_string_literal: true

# This is a simplified version of WasteCarriersEngine::FormsController, since we don't have to worry about changing the
# workflow state or performing additional validations.
class ResourceFormsController < ApplicationController
  include CanFetchResource
  include CanRenewIfPossible
  include CanCompleteIfPossible

  extend ActiveModel::Callbacks
  define_model_callbacks :renew

  prepend_before_action :authenticate_user!
  before_action :authorize_if_required, only: %i[new create]

  def new(form_class, form)
    set_up_form(form_class, form)
  end

  def create(form_class, form, current_user = nil)
    return false unless set_up_form(form_class, form)

    params = send("#{form}_params")

    params[:current_user] = current_user if current_user

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
      run_callbacks :renew do
        renew_if_possible_and_redirect
      end

      true
    else
      render :new
      false
    end
  end

  def authorize_if_required
    send(:authorize_user) if defined?(:authorize_user)
  end

  def renew_if_possible_and_redirect
    if renew_if_possible
      redirect_to resource_finance_details_path(@resource.registration._id)
    else
      complete_if_possible

      redirect_to resource_finance_details_path(@resource._id)
    end
  end
end
