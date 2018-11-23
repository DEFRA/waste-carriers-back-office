# frozen_string_literal: true

class ConvictionsDashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    ordered_and_paged(WasteCarriersEngine::TransientRegistration.pending_approval)
  end

  def possible_matches
    ordered_and_paged(WasteCarriersEngine::TransientRegistration.convictions_possible_match)
  end

  private

  def ordered_and_paged(transient_registrations)
    @transient_registrations = transient_registrations.order_by("metaData.lastModified": :desc)
                                                      .page params[:page]
  end
end
