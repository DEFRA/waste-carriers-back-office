# frozen_string_literal: true

class TransientRegistrationCleanupService < ::WasteCarriersEngine::BaseService
  def run
    transient_registrations_to_remove.destroy_all
  end

  private

  # TransientRegistrations where the last_modified date is earlier than the oldest possible date
  def transient_registrations_to_remove
    WasteCarriersEngine::TransientRegistration.where("metaData.lastModified" => { "$lt" => oldest_possible_date })
  end

  def oldest_possible_date
    max = Rails.configuration.max_transient_registration_age_days
    max.days.ago
  end
end
