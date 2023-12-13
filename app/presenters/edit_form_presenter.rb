# frozen_string_literal: true

class EditFormPresenter < WasteCarriersEngine::BasePresenter
  LOCALES_KEY = ".edit_forms.new.values"

  def created_at
    formatted_datetime = transient_registration.created_at.to_fs(:time_on_day_month_year)

    I18n.t(".edit_forms.new.edit_meta.created_at", created_at: formatted_datetime)
  end

  def updated_at
    formatted_datetime = transient_registration.metaData.last_modified.to_fs(:time_on_day_month_year)

    I18n.t(".edit_forms.new.edit_meta.updated_at", updated_at: formatted_datetime)
  end

  def display_updated_at?
    transient_registration.created_at < transient_registration.metaData.last_modified
  end

  def business_type
    I18n.t("#{LOCALES_KEY}.business_type.#{transient_registration.business_type}")
  end

  def company_name
    transient_registration.company_name
  end

  def registered_company_name
    transient_registration.registered_company_name
  end

  def companies_house_updated_at
    transient_registration.companies_house_updated_at.try(:to_formatted_s, :day_month_year)
  end

  def company_no
    transient_registration.company_no
  end

  def contact_address
    transient_registration.contact_address
  end

  def contact_name
    "#{transient_registration.first_name} #{transient_registration.last_name}"
  end

  def contact_email
    transient_registration.contact_email
  end

  def location
    current_location = transient_registration.location || "not_set"

    I18n.t("#{LOCALES_KEY}.location.#{current_location}")
  end

  def main_people_with_roles
    formatted_people = []
    transient_registration.main_people.each do |person|
      formatted_people << format_main_person(person)
    end

    formatted_people
  end

  def phone_number
    transient_registration.phone_number
  end

  def registered_address
    transient_registration.registered_address
  end

  def registration_type
    return if transient_registration.registration_type.blank?

    I18n.t("#{LOCALES_KEY}.registration_type.#{transient_registration.registration_type}")
  end

  def tier
    I18n.t("#{LOCALES_KEY}.tier.#{transient_registration.tier}")
  end

  def receipt_email
    transient_registration.receipt_email
  end

  private

  def format_main_person(person)
    role = I18n.t("#{LOCALES_KEY}.main_people.#{transient_registration.business_type}", default: "")
    if role.present?
      "#{person_name(person)} (#{role})"
    else
      person_name(person)
    end
  end

  def person_name(person)
    "#{person.first_name} #{person.last_name}"
  end
end
