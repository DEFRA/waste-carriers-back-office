# frozen_string_literal: true

class AdPrivacyPolicyController < ApplicationController
  before_action :authenticate_user!

  def show
    @reg_identifier = params[:reg_identifier]

    @token = params[:token]
    @transient_registration = WasteCarriersEngine::TransientRegistration.where(token: @token).first if @token.present?
  end
end
