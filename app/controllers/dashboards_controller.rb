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
    # Regex to find strings which match the term, with no surrounding characters. The search is case-insensitive.
    exact_match_regex = /\A#{term}\z/i
    # Regex to find strings which include the term. The search is case-insensitive.
    partial_match_regex = /#{term}/i

    WasteCarriersEngine::TransientRegistration.any_of({ reg_identifier: exact_match_regex },
                                                      { company_name: partial_match_regex },
                                                      { last_name: partial_match_regex },
                                                      "addresses.postcode": partial_match_regex)
  end
end
