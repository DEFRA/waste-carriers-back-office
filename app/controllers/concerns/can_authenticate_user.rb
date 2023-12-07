# frozen_string_literal: true

module CanAuthenticateUser
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_and_authorize_active_user
    before_action :check_concurrent_session
  end

  def authenticate_and_authorize_active_user
    return if skip_auth_on_this_controller?

    authenticate_user!
    redirect_to "/bo/pages/deactivated" if current_user_cannot_use_back_office?
  end

  def skip_auth_on_this_controller?
    # Don't authorize and authenticate pages from HighVoltage, Devise, or DefraRubyEmail
    # Normally we'd use a skip_before_action, but these controllers are in gems
    controller = params[:controller]
    controller.include?("pages") || controller.include?("devise") || controller.include?("last-email")
  end

  def current_user_cannot_use_back_office?
    # Don't try to check user permissions if the user isn't logged in
    return false if current_user.blank?

    cannot? :use_back_office, :all
  end

  private

  def check_concurrent_session
    return unless already_logged_in?

    sign_out(current_user)
    redirect_to new_user_session_path, alert: t("sessions.failure.already_authenticated")
  end

  def already_logged_in?
    current_user && session[:login_token] != current_user.current_login_token
  end
end
