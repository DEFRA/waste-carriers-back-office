# frozen_string_literal: true

class ConvictionRejectionFormsController < AdminFormsController
  def new
    super(ConvictionRejectionForm,
          "conviction_rejection_form",
          params[:transient_registration_reg_identifier],
          { authorize_action: :authorize_action })
  end

  def create
    return unless super(ConvictionRejectionForm,
                        "conviction_rejection_form",
                        params[:conviction_rejection_form][:reg_identifier],
                        { authorize_action: :authorize_action,
                          success_path: convictions_checks_in_progress_path })

    reject_renewal
  end

  def authorize_action(transient_registration)
    authorize! :review_convictions, transient_registration
  end

  private

  def reject_renewal
    @transient_registration.conviction_sign_offs.first.reject!
  end
end
