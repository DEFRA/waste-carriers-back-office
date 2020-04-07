# frozen_string_literal: true

module Api
  class RenewalsController < ApplicationController
    before_action :authenticate_user!

    def show
      renewal = WasteCarriersEngine::RenewingRegistration.find_by(reg_identifier: params[:id])

      render json: { _id: renewal.id.to_s, token: renewal.token }
    end
  end
end
