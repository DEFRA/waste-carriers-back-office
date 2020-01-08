# frozen_string_literal: true

module Worldpay
  class RefundService < ::WasteCarriersEngine::BaseService
    include ::WasteCarriersEngine::CanSendWorldpayRequest
    include ::WasteCarriersEngine::CanBuildWorldpayXml

    def run(payment:)
      return false unless payment.worldpay? || payment.worldpay_missed?

      xml = build_refund_xml(payment)
      response = send_request(xml)

      parsed_reponse = Nokogiri::XML(response)

      parsed_reponse.xpath("//paymentService/reply/ok/refundReceived").present?
    end

    private

    def build_refund_xml(payment)
      builder = Nokogiri::XML::Builder.new do |xml|
        build_doctype(xml)

        xml.paymentService(version: "1.4", merchantCode: merchant_code) do
          xml.modify do
            xml.orderModification(orderCode: payment.order_key) do
              xml.refund do
                xml.amount(value: payment.amount, currencyCode: "GBP", exponent: 2)
              end
            end
          end
        end
      end

      builder.to_xml
    end
  end
end
