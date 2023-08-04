# frozen_string_literal: true

module Notify
  class BulkDigitalRenewalNotificationService < ::WasteCarriersEngine::BaseService
    def run(expires_on)
      @expires_on = expires_on

      digital_expiring_registrations.each do |registration|
        if registration.mobile? && WasteCarriersEngine::FeatureToggle.active?(:send_digital_renewal_sms)
          send_sms(registration)
        else
          send_letter(registration)
        end
      end

      digital_expiring_registrations
    end

    private

    def send_letter(registration)
      Notify::DigitalRenewalLetterService.run(registration: registration)
    rescue StandardError => e
      Airbrake.notify e
      Rails.logger.error "Bulk digital renewal letters error:\n#{e}"
    end

    def send_sms(registration)
      Notify::DigitalRenewalSmsService.run(registration: registration)
    rescue StandardError => e
      Airbrake.notify e
      Rails.logger.error "Bulk digital renewal SMS error:\n#{e}"
    end

    def digital_expiring_registrations
      @_digital_expiring_registrations ||= lambda do
        from = @expires_on.beginning_of_day
        to = @expires_on.end_of_day

        WasteCarriersEngine::Registration
          .order_by(reg_identifier: "ASC")
          .active
          .upper_tier
          .not_in(contact_email: [nil, ""])
          .where(expires_on: { :$lte => to, :$gte => from })
      end.call
    end
  end
end
