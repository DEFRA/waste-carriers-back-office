# frozen_string_literal: true

namespace :fix do
  desc "Update renewals in defunct `renewal_received_form` workflow_state"
  task update_renewal_received_form_status: :environment do
    renewals = WasteCarriersEngine::RenewingRegistration.where(workflow_state: "renewal_received_form")

    puts "#{renewals.count} renewals to update"

    renewals.each do |renewal|
      updated_state = if renewal.pending_online_payment?
                        "renewal_received_pending_online_payment_form"
                      elsif renewal.unpaid_balance?
                        "renewal_received_pending_payment_form"
                      else
                        "renewal_received_pending_conviction_form"
                      end

      puts "Changing workflow_state of #{renewal.reg_identifier} to #{updated_state}"
      renewal.update_attribute(:workflow_state, updated_state)
    end
  end
end
