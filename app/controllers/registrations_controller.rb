# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    begin
      registration = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:reg_identifier])
      @back_link = show_back_link
    rescue Mongoid::Errors::DocumentNotFound
      return redirect_to bo_path
    end

    @registration = RegistrationPresenter.new(registration, view_context)
  end

  private

  # The page to link back to depends on page visit history:
  # 1. If the user previously executed a search, point back to search results
  # 2. If there is a HTTP_REFERER, point to that.
  # 3. Otherwise point to the dashboard.
  def show_back_link
    search_link || request.referer || bo_path
  end

  def search_link
    search_term = request.cookies["search_term"]
    return nil if search_term.blank?

    "/bo?term=#{search_term}&commit=#{I18n.t('dashboards.index.search.submit')}"
  end
end
