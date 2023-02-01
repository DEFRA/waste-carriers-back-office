# frozen_string_literal: true

module Notify
  class RegistrationTransferEmailService < ::WasteCarriersEngine::Notify::BaseSendEmailService
    private

    def notify_options
      {
        email_address: @registration.account_email,
        template_id: "d2819465-fca5-462f-bc10-bf557b4c3247",
        personalisation: {
          reg_identifier: @registration.reg_identifier,
          account_email: @registration.account_email,
          company_name: @registration.company_name,
          sign_in_link: "#{Rails.configuration.wcrs_fo_link_domain}/fo/users/sign_in"
        }
      }
    end
  end
end
