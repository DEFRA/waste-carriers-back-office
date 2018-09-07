# frozen_string_literal: true

class RenewabilityCheckService
  def initialize(transient_registration)
    @transient_registration = transient_registration
  end

  def renewal_ready_to_complete?
    # Renewal must have been submitted
    return false unless @transient_registration.renewal_application_submitted?
    # Renewal must not have a pending payment
    return false if @transient_registration.pending_payment?
    # Renewal must not have a pending conviction check
    return false if @transient_registration.conviction_check_required?
    # Renewal status must be active
    return false unless @transient_registration.metaData.ACTIVE?
    true
  end

  def complete_renewal
    return unless renewal_ready_to_complete?

    renewal_completion_service = WasteCarriersEngine::RenewalCompletionService.new(@transient_registration)
    renewal_completion_service.complete_renewal
  end
end
