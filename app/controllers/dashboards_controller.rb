# frozen_string_literal: true

class DashboardsController < ApplicationController
  helper ActionLinksHelper

  before_action :authenticate_user!

  def index
    @term = params[:term]
    @search_type = params[:search_fullname] == "1" ? :fullname : :general
    search_and_count_results(params[:page])
  end

  private

  def search_and_count_results(page)
    result_data = case @search_type
                  when :fullname
                    SearchFullnameService.run(page: page, term: @term)
                  else
                    SearchService.run(page: page, term: @term)
                  end
    @result_count = result_data[:count]
    @results = result_data[:results]
  end
end
