# frozen_string_literal: true

class RemoveDeletableRegistrationsService < ::WasteCarriersEngine::BaseService
  def run
    log "========================"
    remove_registrations_expired_seven_years_ago
    log "========================"
  end

  private

  # Registrations are expired when the `expires_on` date is reached
  # Here we assume that the expiration happened on that date
  def remove_registrations_expired_seven_years_ago
    log "Starting removal of registrations expired < 7 years ago"
    counter = 0

    registrations_expired_seven_years_ago.each do |registration|
      remove_registration(registration)
      counter += 1
    end

    log "Removed #{counter} registration(s)"
  end

  def registrations_expired_seven_years_ago
    WasteCarriersEngine::Registration
      .where("metaData.status" => "EXPIRED")
      .where(:expires_on.lte => 7.years.ago.end_of_day)
  end

  def remove_registration(registration)
    registration.destroy
    log "Removed registration: #{registration.reg_identifier}"
  end

  def log(msg)
    # Avoid cluttering up the test logs
    puts msg unless Rails.env.test?
  end
end
