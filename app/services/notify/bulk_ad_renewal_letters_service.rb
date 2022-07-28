# frozen_string_literal: true

module Notify
  class BulkAdRenewalLettersService < ::WasteCarriersEngine::BaseService
    def run(expires_on)
      @expires_on = expires_on

      ad_expiring_registrations.each do |registration|
        send_letter(registration)
      end

      ad_expiring_registrations
    end

    private

    def send_letter(registration)
      Notify::AdRenewalLetterService.run(registration: registration)
    rescue StandardError => e
      Airbrake.notify e
      Rails.logger.error "Bulk AD renewal letters error:\n#{e}"
    end

    def ad_expiring_registrations
      @_ad_expiring_registrations ||= lambda do
        from = @expires_on.beginning_of_day
        to = @expires_on.end_of_day

        WasteCarriersEngine::Registration
          .order_by(reg_identifier: "ASC")
          .active
          .upper_tier
          .in(contact_email: [nil, ""])
          .where(expires_on: { :$lte => to, :$gte => from })
      end.call
    end
  end
end
