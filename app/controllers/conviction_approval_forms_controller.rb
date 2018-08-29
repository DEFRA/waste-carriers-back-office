# frozen_string_literal: true

class ConvictionApprovalFormsController < AdminFormsController
  def new
    super(ConvictionApprovalForm, "conviction_approval_form", params[:transient_registration_reg_identifier])
  end

  def create
    return unless super(ConvictionApprovalForm,
                        "conviction_approval_form",
                        params[:conviction_approval_form][:reg_identifier])

    update_conviction_sign_off
  end

  private

  def update_conviction_sign_off
    @transient_registration.conviction_sign_offs.first.approve(current_user)
  end
end
