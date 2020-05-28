# frozen_string_literal: true

class TransientRegistrationCleanupService < ::WasteCarriersEngine::BaseService
  def run
    transient_registrations_to_remove.destroy_all
  end

  private

  # Remove any transient_registrations older than the cutoff, unless they are
  # renewals which have already been submitted
  def transient_registrations_to_remove
    WasteCarriersEngine::TransientRegistration.where(
      "metaData.lastModified" => { "$lt" => oldest_possible_date },
      "workflow_state" => { "$nin" => WasteCarriersEngine::RenewingRegistration::SUBMITTED_STATES }
    )
  end

  def oldest_possible_date
    max = Rails.configuration.max_transient_registration_age_days
    max.days.ago
  end
end
