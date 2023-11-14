# frozen_string_literal: true

class RemoveDeletableRegistrationsService < WasteCarriersEngine::BaseService
  def run
    remove_deletable_registrations
  end

  private

  def remove_deletable_registrations
    log "Starting removal of registrations last modified at least 7 years ago"
    counter = 0

    potentially_deletable_registrations.each do |registration|
      # Conviction checks can take some time. Not 7 years, but not clear that it's safe to delete them.
      next if registration.pending_manual_conviction_check?

      remove_registration(registration)
      counter += 1
    end

    log "Removed #{counter} registration(s)"
  end

  def potentially_deletable_registrations
    WasteCarriersEngine::Registration
      .where("metaData.lastModified" => { :$lte => cutoff_date })
      .any_of(
        { "metaData.status": { :$in => %w[EXPIRED INACTIVE REVOKED] } },
        { "financeDetails.balance" => { :$gt => 0.0 } }
      )
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
    puts msg unless Rails.env.test? # rubocop:disable Rails/Output
  end
end
