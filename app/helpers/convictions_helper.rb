# frozen_string_literal: true

module ConvictionsHelper
  def people_convictions
    return "unknown" if unknown_people_convictions?

    @resource.key_person_has_matching_or_unknown_conviction?
  end

  def relevant_people_without_matches
    @resource.relevant_people - people_with_matches
  end

  private

  def people_with_matches
    @resource.key_people.select(&:conviction_check_required?)
  end

  def unknown_people_convictions?
    return true unless @resource.key_people.present?

    # Check to see if any conviction_search_results are present
    conviction_search_results = @resource.key_people.map(&:conviction_search_result).compact
    conviction_search_results.count.zero?
  end
end
