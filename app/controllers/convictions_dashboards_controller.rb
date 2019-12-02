# frozen_string_literal: true

class ConvictionsDashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    ordered_and_paged(list_of_possible_matches)
  end

  def checks_in_progress
    ordered_and_paged(list_of_checks_in_progress)
  end

  def approved
    ordered_and_paged(list_of_approved)
  end

  def rejected
    ordered_and_paged(list_of_rejected)
  end

  private

  def list_of_possible_matches
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_possible_match
  end

  def list_of_checks_in_progress
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_checks_in_progress
  end

  def list_of_approved
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_approved
  end

  def list_of_rejected
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_rejected
  end

  def ordered_and_paged(transient_registrations)
    @transient_registrations = transient_registrations.order_by("metaData.lastModified": :asc)
                                                      .page params[:page]
  end
end
