# frozen_string_literal: true

class ConvictionRejectionFormsController < AdminFormsController
  def new
    super(ConvictionRejectionForm, "conviction_rejection_form", params[:transient_registration_reg_identifier])
  end

  def create
    super(ConvictionRejectionForm, "conviction_rejection_form", params[:conviction_rejection_form][:reg_identifier])
  end
end
