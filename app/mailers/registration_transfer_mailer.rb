# frozen_string_literal: true

class RegistrationTransferMailer < ActionMailer::Base
  helper "waste_carriers_engine/mailer"

  def transfer_to_existing_account_email(registration)
    @registration = registration

    to_address = @registration.account_email
    from_address = "#{Rails.configuration.email_service_name} <#{Rails.configuration.email_service_email}>"
    subject = I18n.t(".registration_transfer_mailer.transfer_to_existing_account_email.subject",
                     reg_identifier: @registration.reg_identifier)

    mail(to: to_address,
         from: from_address,
         subject: subject)
  end
end
