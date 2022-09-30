# frozen_string_literal: true

class BaseConvictionPresenter < WasteCarriersEngine::BasePresenter
  def sign_off
    conviction_sign_offs&.first
  end

  def conviction_status_message
    if sign_off.present?
      I18n.t(".convictions.index.status.#{sign_off.workflow_state}")
    else
      I18n.t(".convictions.index.status.not_required")
    end
  end

  def declared_convictions_message
    if declared_convictions == "yes"
      I18n.t(".convictions.index.declared_convictions.yes")
    elsif declared_convictions == "no"
      I18n.t(".convictions.index.declared_convictions.no")
    else
      I18n.t(".convictions.index.declared_convictions.unknown")
    end
  end

  def business_convictions_message
    if conviction_search_result.blank?
      I18n.t(".convictions.index.business_convictions.unknown")
    elsif business_has_matching_or_unknown_conviction?
      I18n.t(".convictions.index.business_convictions.yes")
    else
      I18n.t(".convictions.index.business_convictions.no")
    end
  end

  def people_convictions_message
    if unknown_people_convictions?
      I18n.t(".convictions.index.people_convictions.unknown")
    elsif key_person_has_matching_or_unknown_conviction?
      I18n.t(".convictions.index.people_convictions.yes")
    else
      I18n.t(".convictions.index.people_convictions.no")
    end
  end

  def display_business_convictions?
    conviction_search_result.present? && business_has_matching_or_unknown_conviction?
  end

  def display_people_convictions?
    !unknown_people_convictions? && key_person_has_matching_or_unknown_conviction?
  end

  def approved_or_revoked?
    conviction_check_approved? || revoked?
  end

  def people_with_matches
    key_people.select(&:conviction_check_required?)
  end

  def relevant_people_without_matches
    relevant_people - people_with_matches
  end

  private

  def unknown_people_convictions?
    return true if key_people.blank?

    # Check to see if any conviction_search_results are present
    conviction_search_results = key_people.map(&:conviction_search_result).compact
    conviction_search_results.count.zero?
  end
end
