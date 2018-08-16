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
    WasteCarriersEngine::TransientRegistration.where(reg_identifier: term)
  end
end
