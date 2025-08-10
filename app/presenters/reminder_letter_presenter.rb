# frozen_string_literal: true

class MissingAddressError < StandardError; end

class ReminderLetterPresenter < WasteCarriersEngine::BasePresenter
  include WasteCarriersEngine::ApplicationHelper
  include ActionView::Helpers::NumberHelper

  def contact_address_lines
    address_lines = displayable_address(contact_address)

    raise MissingAddressError if address_lines.empty?

    address_lines.unshift(company_name)
  end

  def date_of_letter
    Time.zone.now.to_fs(:day_month_year)
  end

  def contact_full_name
    "#{first_name} #{last_name}"
  end

  def expiry_date
    expires_on&.to_date
  end

  def renewal_cost
    puts "\n+++ WCRS_REGISTRATION_CHARGE: #{ENV.fetch('WCRS_REGISTRATION_CHARGE', nil)}" # rubocop:disable Rails/Output
    puts "\n+++ WCRS_RENEWAL_CHARGE:      #{ENV.fetch('WCRS_RENEWAL_CHARGE', nil)}" # rubocop:disable Rails/Output
    puts "\n+++ WCRS_TYPE_CHANGE_CHARGE:  #{ENV.fetch('WCRS_TYPE_CHANGE_CHARGE', nil)}" # rubocop:disable Rails/Output
    puts "\n+++ WCRS_CARD_CHARGE:         #{ENV.fetch('WCRS_CARD_CHARGE', nil)}" # rubocop:disable Rails/Output

    puts "\n+++ renewal_cost: #{Rails.configuration.renewal_charge}" # rubocop:disable Rails/Output
    display_pence_as_pounds(Rails.configuration.renewal_charge)
  end

  def new_reg_cost
    puts "\n+++ new_reg_cost: #{Rails.configuration.new_registration_charge}" # rubocop:disable Rails/Output
    display_pence_as_pounds(Rails.configuration.new_registration_charge)
  end

  def renewal_email_date
    first_reminder_days = Rails.configuration.first_renewal_email_reminder_days.to_i
    (expires_on - first_reminder_days.days).to_date
  end

  def renewal_url
    root_url = Rails.configuration.wcrs_fo_link_domain.split("//").last

    [root_url,
     "/fo/renew/",
     renew_token].join
  end

  def from_email
    Rails.configuration.email_service_email
  end
end
