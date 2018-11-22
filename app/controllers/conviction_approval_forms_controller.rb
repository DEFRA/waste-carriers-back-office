# frozen_string_literal: true

class ConvictionApprovalFormsController < AdminFormsController
  def new
    super(ConvictionApprovalForm,
          "conviction_approval_form",
          params[:transient_registration_reg_identifier],
          :authorize_action)
  end

  def create
    return unless super(ConvictionApprovalForm,
                        "conviction_approval_form",
                        params[:conviction_approval_form][:reg_identifier],
                        :authorize_action)

    update_conviction_sign_off
    renew_if_possible
  end

  def authorize_action(transient_registration)
    authorize! :review_convictions, transient_registration
  end

  private

  def update_conviction_sign_off
    @transient_registration.conviction_sign_offs.first.approve!(current_user)
  end
end
