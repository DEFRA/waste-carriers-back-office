# frozen_string_literal: true

module Reports
  class RegistrationEprPresenter < ::WasteCarriersEngine::BasePresenter
    delegate :uprn, :house_number, :address_line_1, :address_line_2, :address_line_3, :address_line_4,
             :town_city, :postcode, :country, :easting, :northing,
             to: :company_address, prefix: true

    def metadata_date_activated
      metaData&.date_activated&.to_formatted_s(:year_month_day_hyphens)
    end

    def registration_type
      return "carrier_broker_dealer" if lower_tier?

      super
    end

    def expires_on
      return if lower_tier?

      # for renewing registrations, use the original registration's expiry date plus three years
      if __getobj__.instance_of?(WasteCarriersEngine::RenewingRegistration)
        original_expiry = registration.expires_on
        return (original_expiry + 3.years).to_formatted_s(:year_month_day_hyphens)
      end

      return if super.blank?

      return extended_covid_expiry_date(super) if expired_with_covid_extension?(super)

      super.to_formatted_s(:year_month_day_hyphens)
    end

    def company_no
      return unless business_type == "limitedCompany"

      number = super

      return unless number

      number = number.strip

      return if number.chars.uniq == ["0"]

      number
    end

    private

    def expired_with_covid_extension?(original_expires_on)
      end_of_covid_extension = Rails.configuration.end_of_covid_extension

      original_expires_on < end_of_covid_extension
    end

    def extended_covid_expiry_date(original_expires_on)
      (original_expires_on + Rails.configuration.covid_grace_window.days).to_formatted_s(:year_month_day_hyphens)
    end
  end
end
