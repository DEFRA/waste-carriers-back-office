# frozen_string_literal: true

class EditRegistration < WasteCarriersEngine::TransientRegistration
  include WasteCarriersEngine::CanCheckIfRegistrationTypeChanged
  include WasteCarriersEngine::CanCopyDataFromRegistration
  include WasteCarriersEngine::CanUseLock
  include CanUseEditRegistrationWorkflow

  validates :reg_identifier, "waste_carriers_engine/reg_identifier": true

  # IMPORTANT! When specifying attributes be sure to use the name as seen in
  # the database and not the alias in the model. For example use financeDetails
  # not finance_details.
  COPY_DATA_OPTIONS = {
    ignorable_attributes: %w[_id
                             accountEmail
                             addresses
                             expires_on
                             renew_token
                             key_people
                             financeDetails
                             conviction_search_result
                             conviction_sign_offs
                             declaration
                             past_registrations
                             copy_cards
                             deregistration_token
                             deregistration_token_created_at
                             view_certificate_token
                             view_certificate_token_created_at],
    copy_addresses: true,
    copy_people: true
  }.freeze

  def registration
    @_registration ||= WasteCarriersEngine::Registration.find_by(reg_identifier: reg_identifier)
  end

  def prepare_for_payment(mode, user)
    BuildEditFinanceDetailsService.run(
      user: user,
      transient_registration: self,
      payment_method: mode
    )
  end

  def location_changed_from_overseas?
    registration.overseas? && uk_location?
  end
end
