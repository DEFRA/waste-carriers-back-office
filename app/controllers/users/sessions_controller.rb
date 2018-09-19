# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def destroy
      current_user.invalidate_all_sessions!
      super
    end
  end
end
