# frozen_string_literal: true

class FinanceDetailsController < ApplicationController
  before_action :authenticate_user!

  def show
    find_registration(params[:id])

    @finance_details = @registration.finance_details
  end

  private

  def find_registration(id)
    @registration = WasteCarriersEngine::Registration.where("_id" => BSON::ObjectId(id)).first ||
                    WasteCarriersEngine::TransientRegistration.where("_id" => BSON::ObjectId(id)).first
  end
end
