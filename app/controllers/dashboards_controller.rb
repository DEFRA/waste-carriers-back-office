# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transient_registrations = WasteCarriersEngine::TransientRegistration.order_by(:"metaData.last_modified".desc)
                                                                         .page params[:page]
  end
end
