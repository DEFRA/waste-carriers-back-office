# frozen_string_literal: true

class UserRolesController < ApplicationController
  def edit; end

  def update
    redirect_to users_url
  end
end
