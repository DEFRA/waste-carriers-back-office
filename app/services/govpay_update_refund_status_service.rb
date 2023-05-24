# frozen_string_literal: true

class GovpayUpdateRefundStatusService < WasteCarriersEngine::BaseService

  def run(registration:, refund_id:)
    refund = GovpayFindPaymentService.run(payment_id: refund_id)
    return false if refund.blank?

    payment = GovpayFindPaymentService.run(payment_id: refund.refunded_payment_govpay_id)
    return false if payment.blank?

    payment_id = payment.govpay_id

    previous_status = refund.reload.govpay_payment_status
    current_status = GovpayRefundDetailsService.run(refund_id:)["status"]

    return false if current_status == previous_status
    return false if current_status != "success"

    process_success(registration, refund)

    true
  rescue StandardError => e
    Rails.logger.error "#{e.class} error in Govpay update refund details service for payment " \
                       "#{payment_id}, refund #{refund_id}"
    Airbrake.notify(e, message: "Error in Govpay update refund details service", payment_id:, refund_id:)
    raise e
  end

  private

  def process_success(registration, refund)
    refund.update(
      {
        govpay_payment_status: "success",
        comment: I18n.t("refunds.comments.card_complete"),
        order_key: refund.order_key.sub("_PENDING", "_REFUNDED")
      }
    )
    refund.save!

    registration.reload.finance_details.update_balance
    registration.save!
  end
end
