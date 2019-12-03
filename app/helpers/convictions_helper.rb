# frozen_string_literal: true

module ConvictionsHelper
  def relevant_people_without_matches
    @resource.relevant_people - people_with_matches
  end

  private

  def people_with_matches
    @resource.key_people.select(&:conviction_check_required?)
  end
end
