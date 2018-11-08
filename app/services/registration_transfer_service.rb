# frozen_string_literal: true

class RegistrationTransferService
  def initialize(registration)
    @registration = registration
    @transient_registration = find_transient_registration
  end

  def transfer_to_user(email)
    transfer_to_existing_user(email) || transfer_to_new_user(email) || :no_matching_user
  end

  private

  def find_transient_registration
    WasteCarriersEngine::TransientRegistration.where(reg_identifier: @registration.reg_identifier).first
  end

  def transfer_to_existing_user(email)
    return nil unless email.present?

    return unless ExternalUser.where(email: email).first

    # If a matching user exists, transfer and return a success status
    update_account_emails(email)
    send_existing_account_confirmation_email

    :success_existing_user
  end

  def transfer_to_new_user(email)
    return nil unless email.present?

    token = invite_user_and_return_token(email)
    return unless token.present?

    # If a new user is created, transfer and return a success status
    update_account_emails(email)
    send_new_account_confirmation_email(token)

    :success_new_user
  end

  def invite_user_and_return_token(email)
    ExternalUser.invite!(email: email, skip_invitation: true).raw_invitation_token
  end

  def update_account_emails(email)
    update_account_email_for(@registration, email)
    update_account_email_for(@transient_registration, email) if @transient_registration.present?
  end

  def update_account_email_for(registration, email)
    registration.account_email = email
    registration.save!
  end

  def send_existing_account_confirmation_email
    RegistrationTransferMailer.transfer_to_existing_account_email(@registration).deliver_now
  rescue StandardError => e
    log_email_error(e)
  end

  def send_new_account_confirmation_email(token)
    RegistrationTransferMailer.transfer_to_new_account_email(@registration, token).deliver_now
  rescue StandardError => e
    log_email_error(e)
  end

  def log_email_error(error)
    Airbrake.notify(error, reg_identifier: @registration.reg_identifier) if defined?(Airbrake)
    Rails.logger.error "Registration transfer new account confirmation email error: " + error.to_s
  end
end
