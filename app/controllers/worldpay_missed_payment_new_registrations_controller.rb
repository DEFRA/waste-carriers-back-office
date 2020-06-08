# frozen_string_literal: true

class WorldpayMissedPaymentNewRegistrationsController < ApplicationController
  include CanFetchResource

  prepend_before_action :authenticate_user!
  before_action :authorize, only: %i[new]

  def new
    if ready_to_complete_and_add_missed_payment?
      complete_new_registration
      redirect_to new_resource_worldpay_missed_payment_form_path(@registration._id)
    else
      redirect_to new_registration_path(@resource.token)
    end
  end

  private

  def authorize
    authorize! :record_worldpay_missed_payment, @resource
  end

  def ready_to_complete_and_add_missed_payment?
    new_registration? && correct_workflow_state?
  end

  def new_registration?
    @resource.is_a?(WasteCarriersEngine::NewRegistration)
  end

  def correct_workflow_state?
    @resource.workflow_state == "worldpay_form"
  end

  def complete_new_registration
    @registration = WasteCarriersEngine::RegistrationCompletionService.run(@resource)
  end
end
