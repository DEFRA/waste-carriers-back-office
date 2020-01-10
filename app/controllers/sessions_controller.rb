# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_and_authorize_active_user

  def destroy
    current_user.invalidate_all_sessions!
    super
  end
end
