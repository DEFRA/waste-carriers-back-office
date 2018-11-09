# frozen_string_literal: true

class RegistrationTransferMailer < ActionMailer::Base
  helper "waste_carriers_engine/mailer"

  def transfer_to_existing_account_email(registration)
    send_email(registration, ".registration_transfer_mailer.transfer_to_existing_account_email.subject")
  end

  def transfer_to_new_account_email(registration, token)
    @accept_invite_url = accept_invite_url(token)
    send_email(registration, ".registration_transfer_mailer.transfer_to_new_account_email.subject")
  end

  private

  def send_email(registration, subject_text)
    @registration = registration

    to_address = @registration.account_email
    from_address = "#{Rails.configuration.email_service_name} <#{Rails.configuration.email_service_email}>"
    subject = I18n.t(subject_text,
                     reg_identifier: @registration.reg_identifier)

    mail(to: to_address,
         from: from_address,
         subject: subject)
  end

  def accept_invite_url(token)
    [Rails.configuration.wcrs_renewals_url,
     "/fo/users/invitation/accept?invitation_token=",
     token].join
  end
end
