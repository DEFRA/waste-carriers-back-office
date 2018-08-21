# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @term = params[:term]
    @filters = get_filters(params)

    @transient_registrations = Kaminari.paginate_array(find_and_prepare_transient_registrations).page params[:page]
  end

  private

  def find_and_prepare_transient_registrations
    transient_registrations = WasteCarriersEngine::TransientRegistration.all.order_by("metaData.lastModified": :desc)

    transient_registrations = search_results(transient_registrations)
    transient_registrations = filter_results(transient_registrations)

    transient_registrations
  end

  def search_results(transient_registrations)
    return transient_registrations unless @term.present?

    # Regex to find strings which match the term, with no surrounding characters. The search is case-insensitive.
    exact_match_regex = /\A#{@term}\z/i
    # Regex to find strings which include the term. The search is case-insensitive.
    partial_match_regex = /#{@term}/i

    transient_registrations.any_of({ reg_identifier: exact_match_regex },
                                   { company_name: partial_match_regex },
                                   { last_name: partial_match_regex },
                                   "addresses.postcode": partial_match_regex)
  end

  def filter_results(results)
    results = results.select { |tr| tr.renewal_application_submitted? == false } if @filters[:in_progress]
    results = results.select { |tr| tr.pending_payment? == true } if @filters[:pending_payment]
    results = results.select { |tr| tr.pending_manual_conviction_check? == true } if @filters[:pending_conviction_check]

    results
  end

  def get_filters(params)
    {
      in_progress: get_filter_value(params[:in_progress]),
      pending_payment: get_filter_value(params[:pending_payment]),
      pending_conviction_check: get_filter_value(params[:pending_conviction_check])
    }
  end

  def get_filter_value(filter_param)
    filter_param.present? && filter_param == "true"
  end
end
