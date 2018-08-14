# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transient_registrations = WasteCarriersEngine::TransientRegistration.all.page params[:page]
  end
end
