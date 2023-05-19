# frozen_string_literal: true

class GovpayRefundDetailsService < WasteCarriersEngine::BaseService
  include WasteCarriersEngine::CanSendGovpayRequest

  def run(refund_id:)
    @refund = GovpayFindPaymentService.run(payment_id: refund_id)
    raise ArgumentError, "Invalid refund id #{refund_id}" if refund.nil?

    payment_id = refund.refunded_payment_govpay_id
    # we don't use the payment value but this will force a suitable exception if not found
    @payment = GovpayFindPaymentService.run(payment_id:)
    raise ArgumentError, "Invalid refunded payment id #{payment_id}" if payment.nil?

    response
  rescue StandardError => e
    Rails.logger.error "#{e.class} error in Govpay refund details service for payment  " \
                       "#{payment_id}, refund #{refund_id}"
    Airbrake.notify(e, message: "Error in Govpay refund details service", payment_id:, refund_id:)
    raise e
  end

  private

  attr_reader :payment, :refund

  def request
    @request ||=
      send_request(method: :get, path: "/payments/#{payment.govpay_id}/refunds/#{refund.govpay_id}")
  end

  def response
    JSON.parse(request)
  end

  def status_code
    request.code
  end
end
