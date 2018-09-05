# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    find_transient_registration(params[:transient_registration_reg_identifier])
  end

  def create
    find_transient_registration(params[:payment_form][:reg_identifier])
  end

  private

  def find_transient_registration(reg_identifier)
    @transient_registration = WasteCarriersEngine::TransientRegistration.where(reg_identifier: reg_identifier).first
  end
end
