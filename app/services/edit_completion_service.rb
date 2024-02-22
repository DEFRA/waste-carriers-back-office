# frozen_string_literal: true

class EditCompletionService < WasteCarriersEngine::BaseService
  attr_reader :transient_registration

  delegate :registration, to: :transient_registration

  def run(edit_registration:, user: nil)
    @transient_registration = edit_registration

    copy_names_to_contact_address
    create_past_registration
    copy_data_to_registration
    registration.increment_certificate_version(user)
    delete_transient_registration
  end

  private

  def copy_names_to_contact_address
    transient_registration.contact_address.first_name = transient_registration.first_name
    transient_registration.contact_address.last_name = transient_registration.last_name
  end

  def create_past_registration
    WasteCarriersEngine::PastRegistration.build_past_registration(registration, :edit)
  end

  def copy_data_to_registration
    if transient_registration.registration_type_changed?
      WasteCarriersEngine::MergeFinanceDetailsService.call(registration:,
                                                           transient_registration:)
    end
    copy_attributes
    registration.save!
  end

  def delete_transient_registration
    transient_registration.delete
  end

  def copy_attributes
    # IMPORTANT! When specifying attributes be sure to use the name as seen in
    # the database and not the alias in the model. For example use financeDetails
    # not finance_details.
    do_not_copy_attributes = %w[
      _id
      _type
      accountEmail
      created_at
      expires_on
      financeDetails
      token
      workflow_history
      workflow_state
    ].concat(EditRegistration.temp_attributes)

    copyable_attributes = WasteCarriersEngine::SafeCopyAttributesService.run(
      source_instance: transient_registration,
      target_class: WasteCarriersEngine::Registration,
      embedded_documents: %w[addresses metaData financeDetails key_people],
      attributes_to_exclude: do_not_copy_attributes
    )

    registration.write_attributes(copyable_attributes)
  end
end
