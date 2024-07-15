# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    begin
      registration = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:reg_identifier])
      @back_link_target, @back_link_text = back_link
    rescue Mongoid::Errors::DocumentNotFound
      return redirect_to bo_path
    end

    @registration = RegistrationPresenter.new(registration, view_context)
  end

  private

  # If the user previously executed a search, point back to search results; else point to the dashboard.
  def back_link
    search_link_details || [bo_path, I18n.t(".registrations.show.back_link_dashboard")]
  end

  def search_link_details
    search_term = request.cookies["search_term"]
    return nil if search_term.blank?

    [
      "/bo?term=#{search_term}&commit=#{I18n.t('dashboards.index.search.submit')}",
      I18n.t("registrations.show.back_link_search")
    ]
  end
end
