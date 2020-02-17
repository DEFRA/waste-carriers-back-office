# frozen_string_literal: true

class ChargeAdjustFormsController < ApplicationController
  include CanFetchResource

  prepend_before_action :authenticate_user!
  before_action :authorize_user

  def new; end

  def create
    charge_type = params.fetch(:charge_adjust_form, {})[:charge_type]

    if valid_charge_type?(charge_type)
      redirect_to public_send("new_resource_#{charge_type}_charge_adjust_form_path")
    else
      render :new
    end
  end

  private

  def valid_charge_type?(charge_type)
    %w[positive negative].include?(charge_type)
  end

  def authorize_user
    authorize! :charge_adjust, @resource
  end
end
