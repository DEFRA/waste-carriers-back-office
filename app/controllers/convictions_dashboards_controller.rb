# frozen_string_literal: true

class ConvictionsDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_action

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

  def authorize_action
    authorize! :review_convictions, nil
  end

  def list_of_possible_matches
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_possible_match.not_cancelled +
      WasteCarriersEngine::Registration.convictions_possible_match +
      WasteCarriersEngine::Registration.convictions_new_without_status
  end

  def list_of_checks_in_progress
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_checks_in_progress +
      WasteCarriersEngine::Registration.convictions_checks_in_progress
  end

  def list_of_approved
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_approved +
      WasteCarriersEngine::Registration.convictions_approved.where("metaData.status": "PENDING")
  end

  def list_of_rejected
    WasteCarriersEngine::RenewingRegistration.submitted.convictions_rejected
  end

  def ordered_and_paged(matches)
    ordered_matches = matches.sort_by { |match| match.metaData.last_modified }

    @results = Kaminari.paginate_array(ordered_matches).page(params[:page])
  end
end
