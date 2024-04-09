# frozen_string_literal: true

module Notify
  class RenewalReminderEmailService < ::WasteCarriersEngine::Notify::BaseSendEmailService
    TEMPLATE_ID = "6d20d279-ba79-4fe0-9868-fb09c4ae7733"
    COMMS_LABEL = "Upper tier renewal reminder"

    private

    def template_id
      TEMPLATE_ID
    end

    def notify_options
      {
        email_address: ContactEmailValidatorService.run(@registration),
        template_id:,
        personalisation: {
          reg_identifier: @registration.reg_identifier,
          first_name: @registration.first_name,
          last_name: @registration.last_name,
          expires_on: @registration.expires_on.to_fs(:day_month_year),
          renew_fee: renewal_fee,
          renew_link: RenewalMagicLinkService.run(token: @registration.renew_token),
          unsubscribe_link: WasteCarriersEngine::UnsubscribeLinkService.run(registration: @registration)
        }
      }
    end

    def renewal_fee
      display_pence_as_pounds(Rails.configuration.renewal_charge)
    end
  end
end
