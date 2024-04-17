# frozen_string_literal: true

class EditFormPresenter < WasteCarriersEngine::BasePresenter
  LOCALES_KEY = ".edit_forms.new.values"

  delegate :company_name, :company_no, :contact_address, :contact_email, to: :transient_registration
  delegate :phone_number, to: :transient_registration
  delegate :receipt_email, to: :transient_registration
  delegate :registered_address, :registered_company_name, to: :transient_registration

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

  def companies_house_updated_at
    transient_registration.companies_house_updated_at.try(:to_formatted_s, :day_month_year)
  end

  def contact_name
    "#{transient_registration.first_name} #{transient_registration.last_name}"
  end

  def location
    current_location = transient_registration.location || "not_set"

    I18n.t("#{LOCALES_KEY}.location.#{current_location}")
  end

  def main_people_with_roles
    transient_registration.main_people.map do |person|
      format_main_person(person)
    end
  end

  def registration_type
    return if transient_registration.registration_type.blank?

    I18n.t("#{LOCALES_KEY}.registration_type.#{transient_registration.registration_type}")
  end

  def tier
    I18n.t("#{LOCALES_KEY}.tier.#{transient_registration.tier}")
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
