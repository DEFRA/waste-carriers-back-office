# frozen_string_literal: true

module ConvictionsHelper
  def declared_convictions
    return "unknown" unless @transient_registration.declared_convictions.present?
    @transient_registration.declared_convictions == "yes"
  end

  def business_convictions
    return "unknown" unless @transient_registration.conviction_search_result.present?
    @transient_registration.business_has_matching_or_unknown_conviction?
  end

  def people_convictions
    return "unknown" if unknown_people_convictions?
    @transient_registration.key_person_has_matching_or_unknown_conviction?
  end

  private

  def unknown_people_convictions?
    return true unless @transient_registration.key_people.present?

    # Check to see if any conviction_search_results are present
    conviction_search_results = @transient_registration.key_people.map(&:conviction_search_result).compact
    conviction_search_results.count.zero?
  end
end
