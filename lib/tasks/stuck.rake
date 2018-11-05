# frozen_string_literal: true

namespace :fix do
  desc "Fix expired renewals stuck at 'renewal-received' stage"
  task unstick_received: :environment do
    stuck_renewals = WasteCarriersEngine::TransientRegistration.where(workflow_state: "renewal_received_form")
    stuck_renewals.each do |renewal|
      check_service = RenewabilityCheckService.new(renewal)
      can_be_completed = check_service.renewal_ready_to_complete?
      puts "#{renewal.reg_identifier} can be completed? #{can_be_completed}"
      check_service.complete_renewal if can_be_completed
    end
  end
end
