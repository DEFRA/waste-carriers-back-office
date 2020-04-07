# frozen_string_literal: true

module Api
  class RegistrationsController < ApplicationController
    before_action :authenticate_user!

    def show
      registration = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:id])

      render json: { _id: registration.id.to_s }
    end
  end
end
