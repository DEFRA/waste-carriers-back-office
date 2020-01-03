# frozen_string_literal: true

class FinanceDetailsController < ApplicationController
  include CanFetchRegistrationOrTransientRegistration

  before_action :authenticate_user!

  def show
    find_registration(params[:id])

    @finance_details = @registration.finance_details
  end
end
