# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module CanUseEditRegistrationWorkflow
  extend ActiveSupport::Concern
  include Mongoid::Document

  # rubocop:disable Metrics/BlockLength
  included do
    include AASM

    field :workflow_state, type: String

    aasm column: :workflow_state do
      # States / forms
      state :edit_form, initial: true

      # Registration and account
      state :cbd_type_form

      # Business details
      state :company_name_form
      state :main_people_form
      state :company_postcode_form
      state :company_address_form
      state :company_address_manual_form

      # Contact details
      state :contact_name_form
      state :contact_phone_form
      state :contact_email_form
      state :contact_postcode_form
      state :contact_address_form
      state :contact_address_manual_form

      # Complete an edit
      state :declaration_form
      state :edit_payment_summary_form
      state :edit_bank_transfer_form
      state :govpay_form
      state :edit_complete_form

      # Cancel an edit
      state :confirm_edit_cancelled_form
      state :edit_cancelled_form

      # Transition to individual edit forms

      event :edit_cbd_type do
        transitions from: :edit_form,
                    to: :cbd_type_form
      end

      event :edit_company_name do
        transitions from: :edit_form,
                    to: :company_name_form
      end

      event :edit_main_people do
        transitions from: :edit_form,
                    to: :main_people_form
      end

      event :edit_company_address do
        transitions from: :edit_form,
                    to: :company_address_manual_form,
                    if: :based_overseas?

        transitions from: :edit_form,
                    to: :company_postcode_form
      end

      event :edit_contact_name do
        transitions from: :edit_form,
                    to: :contact_name_form
      end

      event :edit_contact_phone do
        transitions from: :edit_form,
                    to: :contact_phone_form
      end

      event :edit_contact_email do
        transitions from: :edit_form,
                    to: :contact_email_form
      end

      event :edit_contact_address do
        transitions from: :edit_form,
                    to: :contact_address_manual_form,
                    if: :based_overseas?

        transitions from: :edit_form,
                    to: :contact_postcode_form
      end

      # Cancellation
      event :cancel_edit do
        transitions from: :edit_form,
                    to: :confirm_edit_cancelled_form
      end

      event :next do
        # Registration and account
        transitions from: :cbd_type_form,
                    to: :edit_form

        # Business details
        transitions from: :company_name_form,
                    to: :edit_form

        transitions from: :main_people_form,
                    to: :edit_form

        # Company address
        transitions from: :company_postcode_form,
                    to: :company_address_manual_form,
                    if: :skip_to_manual_address?

        transitions from: :company_postcode_form,
                    to: :company_address_form

        transitions from: :company_address_form,
                    to: :company_address_manual_form,
                    if: :skip_to_manual_address?

        transitions from: :company_address_form,
                    to: :edit_form

        transitions from: :company_address_manual_form,
                    to: :edit_form

        # Contact details
        transitions from: :contact_name_form,
                    to: :edit_form

        transitions from: :contact_phone_form,
                    to: :edit_form

        transitions from: :contact_email_form,
                    to: :edit_form

        # Contact address
        transitions from: :contact_postcode_form,
                    to: :contact_address_manual_form,
                    if: :skip_to_manual_address?

        transitions from: :contact_postcode_form,
                    to: :contact_address_form

        transitions from: :contact_address_form,
                    to: :contact_address_manual_form,
                    if: :skip_to_manual_address?

        transitions from: :contact_address_form,
                    to: :edit_form

        transitions from: :contact_address_manual_form,
                    to: :edit_form

        # Complete an edit
        transitions from: :edit_form,
                    to: :declaration_form

        transitions from: :declaration_form,
                    to: :edit_complete_form,
                    unless: :registration_type_changed?

        transitions from: :declaration_form,
                    to: :edit_payment_summary_form,
                    if: :registration_type_changed?

        transitions from: :edit_payment_summary_form,
                    to: :govpay_form,
                    if: :paying_by_card?

        transitions from: :edit_payment_summary_form,
                    to: :edit_bank_transfer_form

        transitions from: :edit_bank_transfer_form,
                    to: :edit_complete_form

        transitions from: :govpay_form,
                    to: :edit_complete_form

        # Cancel an edit
        transitions from: :confirm_edit_cancelled_form,
                    to: :edit_cancelled_form
      end

      event :skip_to_manual_address do
        transitions from: :company_postcode_form,
                    to: :company_address_manual_form

        transitions from: :company_address_form,
                    to: :company_address_manual_form

        transitions from: :contact_postcode_form,
                    to: :contact_address_manual_form

        transitions from: :contact_address_form,
                    to: :contact_address_manual_form
      end
    end
    # rubocop:enable Metrics/BlockLength
  end

  private

  def based_overseas?
    overseas?
  end

  def skip_to_manual_address?
    temp_os_places_error
  end

  def paying_by_card?
    temp_payment_method == "card"
  end
end
# rubocop:enable Metrics/ModuleLength
