# frozen_string_literal: true

module CanFetchResource
  extend ActiveSupport::Concern

  included do
    before_action :fetch_resource

    rescue_from BSON::Error::InvalidObjectId do
      redirect_to "/bo/pages/invalid"
    end

    private

    def fetch_resource
      @resource = WasteCarriersEngine::Registration.where("_id" => BSON::ObjectId(params[:resource_id])).first ||
                  WasteCarriersEngine::TransientRegistration.where("_id" => BSON::ObjectId(params[:resource_id])).first
    end
  end
end
