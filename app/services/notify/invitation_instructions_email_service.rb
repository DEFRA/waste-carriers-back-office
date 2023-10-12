# frozen_string_literal: true

module Notify
  class InvitationInstructionsEmailService < DeviseSender
    private

    def invite_url(token)
      Rails.application.routes.url_helpers.accept_user_invitation_url(
        host: Rails.configuration.wcrs_back_office_url,
        invitation_token: token
      )
    end

    def service_url
      Rails.application.routes.url_helpers.root_url(host: Rails.configuration.wcrs_back_office_url)
    end

    def expiry_date(record)
      record.invitation_sent_at + Devise.invite_for
    end

    def notify_options(record, opts)
      {
        email_address: record.email,
        template_id: "5b5c1a42-b19b-4dc1-bece-4842f42edb65",
        personalisation: {
          invite_link: invite_url(opts[:token]),
          service_link: service_url,
          expiry_date: expiry_date(record).to_s(:day_month_year)
        }
      }
    end
  end
end
