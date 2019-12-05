# frozen_string_literal: true

class RegistrationConvictionApprovalFormsController < ApplicationController
  def new
    build_form(params[:registration_reg_identifier])

    authorize_action
  end

  def create
    return false unless build_form(params[:conviction_approval_form][:reg_identifier])

    authorize_action

    submit_form
  end

  private

  def build_form(reg_identifier)
    find_registration(reg_identifier)
    @conviction_approval_form = ConvictionApprovalForm.new(@registration)
  end

  def submit_form
    if @conviction_approval_form.submit(params[:conviction_approval_form])
      redirect_to convictions_path
      true
    else
      render :new
      false
    end
  end

  def find_registration(reg_identifier)
    @registration = WasteCarriersEngine::Registration.find_by(reg_identifier: reg_identifier)
  end

  def authorize_action
    authorize! :review_convictions, @registration
  end
end
