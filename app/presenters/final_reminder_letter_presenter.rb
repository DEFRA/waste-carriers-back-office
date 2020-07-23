# frozen_string_literal: true

class MissingAddressError < StandardError; end

class FinalReminderLetterPresenter < WasteCarriersEngine::BasePresenter
  include WasteCarriersEngine::ApplicationHelper
  include ActionView::Helpers::NumberHelper

  def display_covid_warning?
    WasteCarriersEngine::FeatureToggle.active?(:display_covid_warning_in_letters)
  end

  def contact_address_lines
    address_lines = displayable_address(contact_address)

    raise MissingAddressError if address_lines.empty?

    address_lines.unshift(company_name)
  end

  def date_of_letter
    Time.now.to_date.to_formatted_s(:day_month_year)
  end

  def contact_full_name
    "#{first_name} #{last_name}"
  end

  def expiry_date
    expires_on&.to_date
  end

  def renewal_cost
    display_pence_as_pounds(Rails.configuration.renewal_charge)
  end

  def new_reg_cost
    display_pence_as_pounds(Rails.configuration.new_registration_charge)
  end

  def renewal_email_date
    first_reminder_days = Rails.configuration.first_renewal_email_reminder_days.to_i
    (expires_on - first_reminder_days.days).to_date
  end

  def renewal_url
    root_url = Rails.configuration.wcrs_renewals_url.split("//").last

    [root_url,
     "/fo/renew/",
     renew_token].join
  end
end
