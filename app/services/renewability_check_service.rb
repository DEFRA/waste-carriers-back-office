# frozen_string_literal: true

class RenewabilityCheckService
  def initialize(transient_registration)
    @transient_registration = transient_registration
  end

  def renewal_ready_to_complete?
    return false unless @transient_registration.renewal_application_submitted?
    return false if transient_registration_has_pending_checks?
    return false unless @transient_registration.metaData.ACTIVE?
    true
  end

  def complete_renewal
    return unless renewal_ready_to_complete?

    renewal_completion_service = WasteCarriersEngine::RenewalCompletionService.new(@transient_registration)
    renewal_completion_service.complete_renewal
  end

  private

  def transient_registration_has_pending_checks?
    return true if @transient_registration.pending_payment?
    return true if @transient_registration.conviction_check_required?
    false
  end
end
