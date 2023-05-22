# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_and_authorize_active_user
  skip_before_action :check_concurrent_session

  # POST /resource/sign_in
  def create
    super
    # after the user signs in successfully, set the current login token
    set_login_token
  end

  def destroy
    current_user.invalidate_all_sessions!
    super
  end

  private
  def set_login_token
    token = Devise.friendly_token
    session[:login_token] = token
    current_user.current_login_token = token
    current_user.save
  end
end
