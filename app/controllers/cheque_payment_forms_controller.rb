# frozen_string_literal: true

class ChequePaymentFormsController < AdminFormsController
  def new
    super(ChequePaymentForm,
          "cheque_payment_form",
          params[:transient_registration_reg_identifier],
          { authorize_action: :authorize_action })
  end

  def create
    params[:cheque_payment_form][:updated_by_user] = current_user.email

    return unless super(ChequePaymentForm,
                        "cheque_payment_form",
                        params[:transient_registration_reg_identifier],
                        { authorize_action: :authorize_action })

    renew_if_possible
  end

  def authorize_action(transient_registration)
    authorize! :record_cheque_payment, transient_registration
  end
end
