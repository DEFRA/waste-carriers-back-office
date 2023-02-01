# frozen_string_literal: true

module Notify
  class RegistrationTransferWithInviteEmailService < ::WasteCarriersEngine::Notify::BaseSendEmailService
    def run(registration:, token:)
      @token = token

      super(registration: registration)
    end

    private

    def notify_options
      {
        email_address: @registration.account_email,
        template_id: "98944726-747e-4b40-9d9b-388ada4f57e4",
        personalisation: {
          reg_identifier: @registration.reg_identifier,
          account_email: @registration.account_email,
          company_name: @registration.company_name,
          accept_invite_url: accept_invite_url
        }
      }
    end

    def accept_invite_url
      [Rails.configuration.wcrs_fo_link_domain,
       "/fo/users/invitation/accept?invitation_token=",
       @token].join
    end
  end
end
