# frozen_string_literal: true

class DashboardsController < ApplicationController
  include CanSetFlashMessages

  helper ActionLinksHelper

  before_action :authenticate_user!

  def index
    @term = params[:term]
    @search_type = nil
    @result_count = 0
    @results = []

    if params[:search_fullname] == "1" && params[:search_email] == "1"
      flash_error(I18n.t(".dashboards.index.search.search_type_error"), nil)
    else
      @search_type = search_type(params)
    end

    search_and_count_results(params[:page])
  end

  private

  def search_type(params)
    if params[:search_fullname] == "1"
      :fullname
    elsif params[:search_email] == "1"
      if ValidatesEmailFormatOf.validate_email_format(@term)
        flash_error(I18n.t(".dashboards.index.search.invalid_email_error"), nil)
        nil
      else
        :email
      end
    else
      :general
    end
  end

  def search_and_count_results(page)
    result_data = case @search_type
                  when :fullname
                    SearchFullnameService.run(page: page, term: @term)
                  when :email
                    SearchEmailService.run(page: page, term: @term)
                  when :general
                    SearchService.run(page: page, term: @term)
                  else
                    { count: 0, results: [] }
                  end
    @result_count = result_data[:count]
    @results = result_data[:results]
  end
end
