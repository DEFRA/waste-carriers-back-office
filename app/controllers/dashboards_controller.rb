# frozen_string_literal: true

class DashboardsController < ApplicationController
  helper ActionLinksHelper

  before_action :authenticate_user!

  def index
    @term = params[:term]
    @results = SearchService.run(page: params[:page], term: @term)
  end
end
