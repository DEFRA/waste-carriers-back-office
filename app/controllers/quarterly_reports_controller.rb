# frozen_string_literal: true

class QuarterlyReportsController < ApplicationController

  before_action :authorize_user

  def show
    render :show, locals: { report: Reports::DefraQuarterlyStatsService.run }
  end

  private

  def authorize_user
    authorize! :read, Reports::DefraQuarterlyStatsService, current_user
  end
end
