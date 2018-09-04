# frozen_string_literal: true

class ConvictionRejectionFormsController < AdminFormsController
  def new
    super(ConvictionRejectionForm,
          "conviction_rejection_form",
          params[:transient_registration_reg_identifier],
          :authorize_action)
  end

  def create
    return unless super(ConvictionRejectionForm,
                        "conviction_rejection_form",
                        params[:conviction_rejection_form][:reg_identifier],
                        :authorize_action)

    reject_renewal
  end

  def authorize_action(transient_registration)
    authorize! :review_convictions, transient_registration
  end

  private

  def reject_renewal
    @transient_registration.metaData.revoke!
    @transient_registration.metaData.save!
  end
end
