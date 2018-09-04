# frozen_string_literal: true

class TransferPaymentFormsController < AdminFormsController
  def new
    super(TransferPaymentForm, "transfer_payment_form", params[:transient_registration_reg_identifier])
  end

  def create
    params[:transfer_payment_form][:last_updated_by] = current_user.email

    return unless super(TransferPaymentForm,
                        "transfer_payment_form",
                        params[:transfer_payment_form][:reg_identifier])
  end
end
