# frozen_string_literal: true

class DashboardsController < ApplicationController
  include CanSetFlashMessages

  helper ActionLinksHelper

  before_action :authenticate_user!

  def index
    @term = params[:term]&.strip
    @search_type = nil
    @result_count = 0
    @results = []

    if [params[:search_fullname], params[:search_email], params[:search_reg_identifier]].select do |s|
         s == "1"
       end.count > 1
      flash.now[:error] = I18n.t(".dashboards.index.search.search_type_error")
    else
      @search_type = search_type(params)
    end

    search_and_count_results(params[:page])

    set_search_term_cookie
  end

  private

  def search_type(params)
    if params[:search_fullname] == "1"
      :fullname
    elsif params[:search_email] == "1"
      if ValidatesEmailFormatOf.validate_email_format(@term)
        flash.now[:error] = I18n.t(".dashboards.index.search.invalid_email_error")
        nil
      else
        :email
      end
    elsif params[:search_reg_identifier]
      :reg_identifier
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
                  when :reg_identifier
                    SearchRegIdentifierService.run(page: page, term: @term)
                  when :general
                    SearchService.run(page: page, term: @term)
                  else
                    { count: 0, results: [] }
                  end
    @result_count = result_data[:count]
    @results = result_data[:results]
  end

  def set_search_term_cookie
    cookies[:search_term] = @term if @term.present?
  end
end
