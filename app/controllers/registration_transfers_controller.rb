# frozen_string_literal: true

class RegistrationTransfersController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    redirect_to bo_path
  end
end
