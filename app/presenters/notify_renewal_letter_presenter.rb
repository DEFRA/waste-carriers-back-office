# frozen_string_literal: true

class NotifyRenewalLetterPresenter < WasteCarriersEngine::BasePresenter
  include WasteCarriersEngine::ApplicationHelper
  include ActionView::Helpers::NumberHelper

  def contact_name
    "#{first_name} #{last_name}"
  end

  def expiry_date
    expires_on.to_formatted_s(:unpadded_day_month_year)
  end

  def registration_cost
    display_pence_as_pounds(Rails.configuration.new_registration_charge)
  end

  def renewal_cost
    display_pence_as_pounds(Rails.configuration.renewal_charge)
  end

  def renewal_url
    root_url = Rails.configuration.wcrs_fo_link_domain.split("//").last

    [root_url,
     "/fo/renew/",
     renew_token].join
  end

  def renewal_email_date
    first_reminder_days = Rails.configuration.first_renewal_email_reminder_days.to_i
    (expires_on - first_reminder_days.days).to_date
  end
end
