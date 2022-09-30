# frozen_string_literal: true

class RemoveDeletableRegistrationsService < ::WasteCarriersEngine::BaseService
  def run
    remove_deletable_registrations
  end

  private

  def remove_deletable_registrations
    log "Starting removal of registrations last modified at least 7 years ago"
    counter = 0

    deletable_registrations.each do |registration|
      remove_registration(registration)
      counter += 1
    end

    log "Removed #{counter} registration(s)"
  end

  def deletable_registrations
    WasteCarriersEngine::Registration
      .where("metaData.status" => { "$in": %w[EXPIRED INACTIVE REVOKED] })
      .where("metaData.lastModified" => { :$lte => cutoff_date })
  end

  def remove_registration(registration)
    registration.destroy
    log "Removed registration: #{registration.reg_identifier}"
  end

  def cutoff_date
    Rails.configuration.data_retention_years.to_i.years.ago.end_of_day
  end

  def log(msg)
    # Avoid cluttering up the test logs
    puts msg unless Rails.env.test?
  end
end
