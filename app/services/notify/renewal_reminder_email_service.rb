# frozen_string_literal: true

module Notify
  class RenewalReminderEmailService < ::WasteCarriersEngine::Notify::BaseSendEmailService
    private

    def notify_options
      {
        email_address: validate_contact_email(@registration),
        template_id: "51cfcf60-7506-4ee7-9400-92aa90cf983c",
        personalisation: {
          reg_identifier: @registration.reg_identifier,
          first_name: @registration.first_name,
          last_name: @registration.last_name,
          expires_on: @registration.expires_on.to_formatted_s(:day_month_year),
          renew_fee: renewal_fee,
          renew_link: RenewalMagicLinkService.run(token: @registration.renew_token)
        }
      }
    end

    def renewal_fee
      display_pence_as_pounds(Rails.configuration.renewal_charge)
    end

    def validate_contact_email(registration)
      raise Exceptions::MissingContactEmailError, registration.reg_identifier unless registration.contact_email.present?

      assisted_digital_match = registration.contact_email == WasteCarriersEngine.configuration.assisted_digital_email

      raise Exceptions::AssistedDigitalContactEmailError, registration.reg_identifier if assisted_digital_match

      registration.contact_email
    end
  end
end
