# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @term = params[:term]
    @filters = get_filters(params)

    service = TransientRegistrationFinderService.new(@term, @filters)
    @transient_registrations = Kaminari.paginate_array(service.transient_registrations).page params[:page]
  end

  private

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
