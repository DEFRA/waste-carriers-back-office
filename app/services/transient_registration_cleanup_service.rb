# frozen_string_literal: true

class TransientRegistrationCleanupService < WasteCarriersEngine::BaseService
  def run
    transient_registrations_with_created_at = transient_registrations_to_remove
    transient_registrations_without_created_at = no_created_at_transient_registrations_to_remove

    # rubocop:disable Rails/Output
    # :nocov:
    unless Rails.env.test?
      puts "Removing transient_registrations created up to #{oldest_possible_date} excluding #{excluded_states}"
      puts "Removing #{transient_registrations_with_created_at.count} transient_registrations with a created_at value"
      puts "Removing #{transient_registrations_without_created_at.count} transient_registrations " \
           "without a created_at value"
    end
    # :nocov:
    # rubocop:enable Rails/Output

    transient_registrations_with_created_at.destroy_all
    transient_registrations_without_created_at.destroy_all
  end

  private

  # Remove any transient_registrations older than the cutoff, unless they are
  # renewals which have already been submitted
  def transient_registrations_to_remove
    WasteCarriersEngine::TransientRegistration.where(
      "created_at" => { "$lt" => oldest_possible_date },
      "workflow_state" => { "$nin" => excluded_states }
    )
  end

  # Older transient_registrations may not have a created_at attribute. When
  # this is the case, we go off the value of last_modified instead.
  def no_created_at_transient_registrations_to_remove
    WasteCarriersEngine::TransientRegistration.where(
      "created_at" => nil,
      "metaData.lastModified" => { "$lt" => oldest_possible_date },
      "workflow_state" => { "$nin" => excluded_states }
    )
  end

  def oldest_possible_date
    @oldest_possible_date = Rails.configuration.max_transient_registration_age_days.to_i.days.ago
  end

  def excluded_states
    # we also remove submitted-but-pending-payment transient_registrations older than the cutoff
    @excluded_states ||= WasteCarriersEngine::RenewingRegistration::SUBMITTED_STATES - %w[
      renewal_received_pending_payment_form
      registration_received_pending_payment_form
    ]
  end
end
