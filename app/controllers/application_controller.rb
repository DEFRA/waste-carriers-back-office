# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :back_button_cache_buster

  helper WasteCarriersEngine::ApplicationHelper

  # Within our production 'like' environments access to the app can only be
  # obtained through `/bo`. Therefore to make this clear and ensure there is
  # no confusion we redirect all requests to `/` to `/bo`
  # https://stackoverflow.com/a/28822626/6117745
  def redirect_root_to_dashboard
    redirect_to bo_path
  end

  # We need to handle users coming to the app via /bo/renew/CBDU12345 that are
  # first required to sign in, and those that just come straight to the sign in
  # page. In the first case we need to redirect them back to /bo/renew/CBDU12345
  # after sign in, which we're able to do thanks to a handy helper method in
  # Devise which stores the previous url. In the second case we redirect them to
  # our dashboard.
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || bo_path
  end

  def after_sign_out_path_for(*)
    new_user_session_path
  end

  rescue_from CanCan::AccessDenied do
    redirect_to "/bo/pages/permission"
  end

  # http://jacopretorius.net/2014/01/force-page-to-reload-on-browser-back-in-rails.html
  def back_button_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
