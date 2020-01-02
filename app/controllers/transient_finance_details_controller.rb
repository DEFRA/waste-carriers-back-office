# frozen_string_literal: true

class TransientFinanceDetailsController < ApplicationController
  before_action :authenticate_user!

  def show
    find_registration(params[:transient_registration_token])

    @finance_details = @transient_registration.finance_details
  end

  private

  def find_registration(token)
    @transient_registration = WasteCarriersEngine::TransientRegistration.where(token: token).first
  end
end
