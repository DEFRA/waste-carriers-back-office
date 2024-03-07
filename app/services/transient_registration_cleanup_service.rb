# frozen_string_literal: true

class TransientRegistrationCleanupService < WasteCarriersEngine::BaseService

  def run
    console_log "Removing transient_registrations created up to #{oldest_possible_date} excluding #{excluded_states}"

    transient_registrations_with_created_at = transient_registrations_to_remove
    console_log "Removing #{transient_registrations_with_created_at.count} transient_registrations " \
                "with a created_at value:"
    remove_transient_registrations transient_registrations_with_created_at

    transient_registrations_without_created_at = no_created_at_transient_registrations_to_remove
    console_log "Removing #{transient_registrations_without_created_at.count} transient_registrations " \
                "without a created_at value:"
    remove_transient_registrations transient_registrations_without_created_at
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

  def remove_transient_registrations(transient_registrations)
    resolve_invalid_transient_registration_types

    transient_registrations.each do |transient_registration|
      console_log transient_registration.reg_identifier
      transient_registration.destroy
    end
  end

  def resolve_invalid_transient_registration_types
    # Check for transient_registrations with invalid `_type`, which identifies the subtype of transient_registration.
    # For example, a transient_registration of type `EditRegistration` may have been created but the class
    # `EditRegistration` has now been renamed `BackOfficeEditRegistration`. If transient_registrations
    # of the old type remain in the DB, iterating and instantiating will fail. So we temporarily define a
    # subclass of TransientRegistration with the missing name so that the doomed transient_registration can be
    # instantiated and destroyed.
    valid_transient_registration_types = WasteCarriersEngine::TransientRegistration.descendants
    invalid_transient_registration_types = WasteCarriersEngine::TransientRegistration
                                           .where(_type: { "$nin": valid_transient_registration_types })
                                           .pluck(:_type).uniq

    return if invalid_transient_registration_types.empty?

    # Temporarily create a class definition for each invalid type, to allow those
    # transient_registrations to be instantiated and destroyed:
    invalid_transient_registration_types.each do |type_name|
      console_log "Handling obsolete transient registration type #{type_name}"
      Object.const_set type_name, Class.new(WasteCarriersEngine::TransientRegistration)
    end
  end

  # rubocop:disable Rails/Output
  def console_log(text)
    # :nocov:
    puts text unless Rails.env.test?
    # :nocov:
  end
  # rubocop:enable Rails/Output
end
