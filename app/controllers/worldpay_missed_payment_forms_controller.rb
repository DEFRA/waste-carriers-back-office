# frozen_string_literal: true

class WorldpayMissedPaymentFormsController < ResourceFormsController
  before_renew :change_state_if_possible

  def new
    super(WorldpayMissedPaymentForm, "worldpay_missed_payment_form")
  end

  def create
    params[:worldpay_missed_payment_form][:updated_by_user] = current_user.email

    super(WorldpayMissedPaymentForm, "worldpay_missed_payment_form")
  end

  private

  def worldpay_missed_payment_form_params
    params.fetch(:worldpay_missed_payment_form, {}).permit(
      :amount,
      :comment,
      :registration_reference,
      :date_received_day,
      :date_received_month,
      :date_received_year,
      :updated_by_user
    )
  end

  def authorize_user
    authorize! :record_worldpay_missed_payment, @resource
  end

  def change_state_if_possible
    @resource.next! if @resource.workflow_state == "worldpay_form"
  end
end
