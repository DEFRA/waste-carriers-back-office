# frozen_string_literal: true

class DashboardsController < ApplicationController
  helper ActionLinksHelper

  before_action :authenticate_user!

  def index
    @term = params[:term]
    search_and_count_results(params[:page])
  end

  private

  def search_and_count_results(page)
    result_data = SearchService.run(page: page, term: @term)
    @result_count = result_data[:count]
    @results = result_data[:results]
  end
end
