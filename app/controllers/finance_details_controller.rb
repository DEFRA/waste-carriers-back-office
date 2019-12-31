# frozen_string_literal: true

class FinanceDetailsController < ApplicationController
  before_action :authenticate_user!

  def show
    find_registration(params[:registration_reg_identifier])

    @finance_details = @registration.finance_details
  end

  private

  def find_registration(reg_identifier)
    @registration = WasteCarriersEngine::Registration.where(reg_identifier: reg_identifier).first
  end
end
