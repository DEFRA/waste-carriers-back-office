# frozen_string_literal: true

module CanFetchRegistrationOrTransientRegistration
  extend ActiveSupport::Concern

  included do
    private

    def find_registration(id)
      @registration = WasteCarriersEngine::Registration.where("_id" => BSON::ObjectId(id)).first ||
                      WasteCarriersEngine::TransientRegistration.where("_id" => BSON::ObjectId(id)).first
    end
  end
end
