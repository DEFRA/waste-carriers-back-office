# frozen_string_literal: true

class FinanceDetailsController < ApplicationController
  include CanFetchResource

  prepend_before_action :authenticate_user!

  def show
    @finance_details = @resource.finance_details
  end
end
