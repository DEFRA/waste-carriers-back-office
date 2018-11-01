# frozen_string_literal: true

class RegistrationTransferService
  def initialize(registration)
    @registration = registration
    @transient_registration = find_transient_registration
  end

  def transfer_to_user(email)
    @recipient_user = find_user(email)
    return :no_matching_user if @recipient_user.blank?

    update_account_email_for(@registration)
    update_account_email_for(@transient_registration) if @transient_registration.present?

    send_confirmation_email

    :success_existing_user
  end

  private

  def find_transient_registration
    WasteCarriersEngine::TransientRegistration.where(reg_identifier: @registration.reg_identifier).first
  end

  def find_user(email)
    return nil unless email.present?

    ExternalUser.where(email: email).first
  end

  def update_account_email_for(registration)
    registration.account_email = @recipient_user.email
    registration.save!
  end

  def send_confirmation_email
    RegistrationTransferMailer.transfer_to_existing_account_email(@registration).deliver_now
  rescue StandardError => e
    Airbrake.notify(e) if defined?(Airbrake)
    Rails.logger.error "Registration transfer confirmation email error: " + e.to_s
  end
end
