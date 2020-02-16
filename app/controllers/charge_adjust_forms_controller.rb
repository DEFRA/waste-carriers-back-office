# frozen_string_literal: true

class ChargeAdjustFormsController < ApplicationController
  include CanFetchResource

  prepend_before_action :authenticate_user!
  before_action :authorize_user
  before_action :fetch_form

  def new; end

  def create
    @charge_adjust_form.submit(charge_adjust_form_attributes)

    if @charge_adjust_form.valid?
      redirect_to public_send("new_resource_#{@charge_adjust_form.charge_type}_charge_adjust_form_path")
    else
      render :new
    end
  end

  private

  def charge_adjust_form_attributes
    params.fetch(:charge_adjust_form, {}).permit(:charge_type)
  end

  def authorize_user
    authorize! :charge_adjust, @resource
  end

  def fetch_form
    @charge_adjust_form = ChargeAdjustForm.new
  end
end
