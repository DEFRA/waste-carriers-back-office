# frozen_string_literal: true

class FinanceDetailsController < ApplicationController
  include CanFetchResource

  prepend_before_action :authenticate_user!

  def show
    @resource = RegistrationPresenter.new(@resource, view_context)
    @finance_details = @resource.finance_details
  end
end
