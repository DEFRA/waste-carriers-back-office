# frozen_string_literal: true

module ConvictionsHelper
  def declared_convictions
    return "unknown" unless @resource.declared_convictions.present?

    @resource.declared_convictions == "yes"
  end

  def business_convictions
    return "unknown" unless @resource.conviction_search_result.present?

    @resource.business_has_matching_or_unknown_conviction?
  end

  def people_convictions
    return "unknown" if unknown_people_convictions?

    @resource.key_person_has_matching_or_unknown_conviction?
  end

  def people_with_matches
    @resource.key_people.select(&:conviction_check_required?)
  end

  def relevant_people_without_matches
    @resource.relevant_people - people_with_matches
  end

  def conviction_sign_off
    return unless @resource.conviction_sign_offs.present?

    @resource.conviction_sign_offs.first
  end

  private

  def unknown_people_convictions?
    return true unless @resource.key_people.present?

    # Check to see if any conviction_search_results are present
    conviction_search_results = @resource.key_people.map(&:conviction_search_result).compact
    conviction_search_results.count.zero?
  end
end
