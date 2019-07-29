# frozen_string_literal: true

class AdPrivacyPolicyController < ApplicationController
  before_action :authenticate_user!

  def show
    @reg_identifier = params[:reg_identifier]
  end
end
