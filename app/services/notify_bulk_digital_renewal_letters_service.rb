# frozen_string_literal: true

class NotifyBulkDigitalRenewalLettersService < ::WasteCarriersEngine::BaseService
  def run(expires_on)
    @expires_on = expires_on

    digital_expiring_registrations.each do |registration|
      send_letter(registration)
    end

    digital_expiring_registrations
  end

  private

  def send_letter(registration)
    NotifyDigitalRenewalLetterService.run(registration: registration)
  rescue StandardError => e
    Airbrake.notify e
    Rails.logger.error "Bulk AD renewal letters error:\n#{e}"
  end

  def digital_expiring_registrations
    @_digital_expiring_registrations ||= lambda do
      from = @expires_on.beginning_of_day
      to = @expires_on.end_of_day

      WasteCarriersEngine::Registration
        .order_by(reg_identifier: "ASC")
        .active
        .upper_tier
        .not_in(contact_email: [WasteCarriersEngine.configuration.assisted_digital_email, nil, ""])
        .where(expires_on: { :$lte => to, :$gte => from })
    end.call
  end
end
