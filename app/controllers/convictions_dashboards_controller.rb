# frozen_string_literal: true

class ConvictionsDashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transient_registrations = WasteCarriersEngine::TransientRegistration.pending_approval.page params[:page]
  end
end
