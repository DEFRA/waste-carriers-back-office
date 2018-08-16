# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    term = params[:term]
    relevant_transient_registrations = if term.present?
                                         search_results(term)
                                       else
                                         WasteCarriersEngine::TransientRegistration.all
                                       end
    @transient_registrations = relevant_transient_registrations.order_by("metaData.lastModified": :desc)
                                                               .page params[:page]
  end

  private

  def search_results(term)
    # Regex to find strings which include the term. The search is case-insensitive.
    matching_regex = /#{term}/i

    WasteCarriersEngine::TransientRegistration.any_of({ reg_identifier: matching_regex },
                                                      { company_name: matching_regex },
                                                      { last_name: matching_regex },
                                                      "addresses.postcode": matching_regex)
  end
end
