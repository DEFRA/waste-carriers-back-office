# frozen_string_literal: true

class RegistrationTransferService
  def initialize(registration)
    @registration = registration
    @transient_registration = find_transient_registration
  end

  def transfer_to_user(email)
    find_user(email) || create_new_user(email) || :no_matching_user
  end

  private

  def find_transient_registration
    WasteCarriersEngine::TransientRegistration.where(reg_identifier: @registration.reg_identifier).first
  end

  def find_user(email)
    return nil unless email.present?

    return unless ExternalUser.where(email: email).first

    # If a matching user exists, transfer and return a success status
    update_account_emails(email)
    send_existing_account_confirmation_email

    :success_existing_user
  end

  def create_new_user(email)
    return nil unless email.present?

    return unless ExternalUser.invite!(email: email, skip_invitation: true)

    # If a new user is created, transfer and return a success status
    update_account_emails(email)
    send_new_account_confirmation_email

    :success_new_user
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

  def send_new_account_confirmation_email
    RegistrationTransferMailer.transfer_to_new_account_email(@registration).deliver_now
  rescue StandardError => e
    log_email_error(e)
  end

  def log_email_error(error)
    Airbrake.notify(error) if defined?(Airbrake)
    Rails.logger.error "Registration transfer new account confirmation email error: " + error.to_s
  end
end
