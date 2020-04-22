# frozen_string_literal: true

module Api
  class RegistrationsController < ApplicationController
    def show
      registration = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:id])

      render json: { _id: registration.id.to_s }
    end

    def create
      raw_data = JSON.parse(request.body.read)
      registration = LoadSeededDataService.run(raw_data)

      render json: { reg_identifier: registration.reg_identifier }
    end

    def verified_request?
      # Given that we are sending post create data via raw JSON, we don't want Rails
      # to complain about a missing forgery token
      true
    end

    def skip_auth_on_this_controller?
      # Given that this API will never be available in production servers, and adding
      # authentication to the seed `create` requests will add complexity, we will not
      # request authentication on these endpoints.
      true
    end
  end
end
