# frozen_string_literal: true

class CeasedOrRevokedCompletionService < WasteCarriersEngine::BaseService
  attr_reader :transient_registration, :registration, :current_user

  def run(transient_registration:, user:)
    @transient_registration = transient_registration
    @registration = transient_registration.registration
    @current_user = user

    merge_metadata
    destroy_transient_object
  end

  private

  def destroy_transient_object
    transient_registration.destroy
  end

  def merge_metadata
    WasteCarriersEngine::RegistrationDeactivationService.run(
      registration:,
      reason: transient_registration.metaData.revoked_reason,
      email: current_user&.email,
      status: transient_registration.metaData.status
    )
  end
end
