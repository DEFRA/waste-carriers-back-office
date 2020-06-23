# frozen_string_literal: true

class TransientRegistrationCleanupService < ::WasteCarriersEngine::BaseService
  def run
    transient_registrations_to_remove.destroy_all
    no_created_at_transient_registrations_to_remove.destroy_all
  end

  private

  # Remove any transient_registrations older than the cutoff, unless they are
  # renewals which have already been submitted
  def transient_registrations_to_remove
    WasteCarriersEngine::TransientRegistration.where(
      "created_at" => { "$lt" => oldest_possible_date },
      "workflow_state" => { "$nin" => WasteCarriersEngine::RenewingRegistration::SUBMITTED_STATES }
    )
  end

  # Older transient_registrations may not have a created_at attribute. When
  # this is the case, we go off the value of last_modified instead.
  def no_created_at_transient_registrations_to_remove
    WasteCarriersEngine::TransientRegistration.where(
      "created_at" => nil,
      "metaData.lastModified" => { "$lt" => oldest_possible_date },
      "workflow_state" => { "$nin" => WasteCarriersEngine::RenewingRegistration::SUBMITTED_STATES }
    )
  end

  def oldest_possible_date
    max = Rails.configuration.max_transient_registration_age_days.to_i
    max.days.ago
  end
end
