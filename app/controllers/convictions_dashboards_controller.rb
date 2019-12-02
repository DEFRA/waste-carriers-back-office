# frozen_string_literal: true

class ConvictionsDashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    ordered_and_paged(WasteCarriersEngine::RenewingRegistration.submitted.convictions_possible_match)
  end

  def checks_in_progress
    ordered_and_paged(WasteCarriersEngine::RenewingRegistration.submitted.convictions_checks_in_progress)
  end

  def approved
    ordered_and_paged(WasteCarriersEngine::RenewingRegistration.submitted.convictions_approved)
  end

  def rejected
    ordered_and_paged(WasteCarriersEngine::RenewingRegistration.submitted.convictions_rejected)
  end

  private

  def ordered_and_paged(transient_registrations)
    @transient_registrations = transient_registrations.order_by("metaData.lastModified": :asc)
                                                      .page params[:page]
  end
end
