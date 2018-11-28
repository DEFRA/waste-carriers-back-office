# frozen_string_literal: true

class CashPaymentFormsController < AdminFormsController
  def new
    super(CashPaymentForm,
          "cash_payment_form",
          params[:transient_registration_reg_identifier],
          { authorize_action: :authorize_action })
  end

  def create
    params[:cash_payment_form][:updated_by_user] = current_user.email

    return unless super(CashPaymentForm,
                        "cash_payment_form",
                        params[:cash_payment_form][:reg_identifier],
                        { authorize_action: :authorize_action })

    renew_if_possible
  end

  def authorize_action(transient_registration)
    authorize! :record_cash_payment, transient_registration
  end
end
