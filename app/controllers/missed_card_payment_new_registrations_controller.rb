# frozen_string_literal: true

class MissedCardPaymentNewRegistrationsController < ApplicationController
  include CanFetchResource

  prepend_before_action :authenticate_user!
  before_action :authorize, only: %i[new]

  def new
    if ready_to_complete_and_add_missed_payment?
      complete_new_registration
      redirect_to new_resource_missed_card_payment_form_path(@registration._id)
    else
      redirect_to new_registration_path(@resource.token)
    end
  end

  private

  def authorize
    authorize! :record_missed_card_payment, @resource
  end

  def ready_to_complete_and_add_missed_payment?
    new_registration? && correct_workflow_state?
  end

  def new_registration?
    @resource.is_a?(WasteCarriersEngine::NewRegistration)
  end

  def correct_workflow_state?
    @resource.workflow_state == "govpay_form"
  end

  def complete_new_registration
    @registration = WasteCarriersEngine::RegistrationCompletionService.run(@resource)
  end
end
