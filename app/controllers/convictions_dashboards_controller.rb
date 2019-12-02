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
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_possible_match +
      WasteCarriersEngine::Registration.convictions_possible_match
  end

  def list_of_checks_in_progress
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_checks_in_progress +
      WasteCarriersEngine::Registration.convictions_checks_in_progress
  end

  def list_of_approved
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_approved
  end

  def list_of_rejected
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_rejected
  end

  def ordered_and_paged(matches)
    ordered_matches = matches.sort_by { |match| match.metaData.last_modified }

    @transient_registrations = Kaminari.paginate_array(ordered_matches).page(params[:page])
  end
end
