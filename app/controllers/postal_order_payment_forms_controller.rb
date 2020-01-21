# frozen_string_literal: true

class PostalOrderPaymentFormsController < ResourceFormsController
  include CanRenewIfPossible

  def new
    super(PostalOrderPaymentForm,
          "postal_order_payment_form")
  end

  def create
    params[:postal_order_payment_form][:updated_by_user] = current_user.email

    return unless super(PostalOrderPaymentForm,
                        "postal_order_payment_form")
  end

  private

  def postal_order_payment_form_params
    params.fetch(:postal_order_payment_form, {}).permit(
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
    authorize! :record_postal_order_payment, @resource
  end
end
