# frozen_string_literal: true

class ConvictionApprovalFormsController < AdminFormsController
  def new
    super(ConvictionApprovalForm, "conviction_approval_form", params[:transient_registration_reg_identifier])
  end

  def create
    super(ConvictionApprovalForm, "conviction_approval_form", params[:conviction_approval_form][:reg_identifier])
  end
end
