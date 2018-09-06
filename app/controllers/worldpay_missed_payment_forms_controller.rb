# frozen_string_literal: true

class WorldpayMissedPaymentFormsController < AdminFormsController
  def new
    super(WorldpayMissedPaymentForm,
          "worldpay_missed_payment_form",
          params[:transient_registration_reg_identifier],
          :authorize_action)
  end

  def create
    params[:worldpay_missed_payment_form][:updated_by_user] = current_user.email

    return unless super(WorldpayMissedPaymentForm,
                        "worldpay_missed_payment_form",
                        params[:worldpay_missed_payment_form][:reg_identifier],
                        :authorize_action)
  end

  def authorize_action(transient_registration)
    authorize! :record_worldpay_missed_payment, transient_registration
  end
end
