# frozen_string_literal: true

namespace :fix do
  desc "Fix expired renewals stuck at 'renewal-received' stage"
  task unstick_received: :environment do
    stuck_renewals = WasteCarriersEngine::RenewingRegistration.in(
      workflow_state: WasteCarriersEngine::RenewingRegistration::SUBMITTED_STATES
    )
    stuck_renewals.each do |renewal|
      completion_service = WasteCarriersEngine::RenewalCompletionService.new(renewal)
      can_be_completed = completion_service.can_be_completed?
      puts "#{renewal.reg_identifier} can be completed? #{can_be_completed}"

      completion_service.complete_renewal if can_be_completed
    end
  end
end
