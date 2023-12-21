# frozen_string_literal: true

class CommunicationRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    find_resource(params)
    authorize! :view_communication_history, @resource

    @communication_records = @resource.communication_records.order(sent_at: :desc).page(params[:page]).per(10)
  end

  protected

  def find_resource(params)
    return if params[:registration_reg_identifier].blank?

    @resource = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:registration_reg_identifier])
  end
end
