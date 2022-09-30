# frozen_string_literal: true

class RegistrationTransferService < ::WasteCarriersEngine::BaseService
  def run(registration:, email:)
    @registration = registration
    @transient_registration = find_transient_registration
    @email = email

    transfer_to_existing_user || transfer_to_new_user || :no_matching_user
  end

  private

  def find_transient_registration
    WasteCarriersEngine::RenewingRegistration.where(reg_identifier: @registration.reg_identifier).first
  end

  def transfer_to_existing_user
    return nil if @email.blank?

    return unless ExternalUser.where(email: @email).first

    # If a matching user exists, transfer and return a success status
    update_account_emails
    send_existing_account_confirmation_email

    :success_existing_user
  end

  def transfer_to_new_user
    return nil if @email.blank?

    token = invite_user_and_return_token
    return if token.blank?

    # If a new user is created, transfer and return a success status
    update_account_emails
    send_new_account_confirmation_email(token)

    :success_new_user
  end

  def invite_user_and_return_token
    ExternalUser.invite!(email: @email, skip_invitation: true).raw_invitation_token
  end

  def update_account_emails
    update_account_email_for(@registration)
    update_account_email_for(@transient_registration) if @transient_registration.present?
  end

  def update_account_email_for(record)
    record.account_email = @email
    record.save!
  end

  def send_existing_account_confirmation_email
    Notify::RegistrationTransferEmailService.run(registration: @registration)
  rescue StandardError => e
    log_email_error(e)
  end

  def send_new_account_confirmation_email(token)
    Notify::RegistrationTransferWithInviteEmailService
      .run(registration: @registration, token: token)
  rescue StandardError => e
    log_email_error(e)
  end

  def log_email_error(error)
    Airbrake.notify(error, reg_identifier: @registration.reg_identifier) if defined?(Airbrake)
    Rails.logger.error "Registration transfer confirmation email error: #{error.to_s}"
  end
end
