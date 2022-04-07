# frozen_string_literal: true

module Worldpay
  class RefundService < ::WasteCarriersEngine::BaseService
    include ::WasteCarriersEngine::CanSendWorldpayRequest
    include ::WasteCarriersEngine::CanBuildWorldpayXml

    def run(payment:, amount:, merchant_code:)
      return false unless payment.online? || payment.online_missed?

      @payment = payment
      @amount = amount
      @merchant_code = merchant_code

      response = send_request(xml)
      parsed_reponse = Nokogiri::XML(response)

      parsed_reponse.xpath("//paymentService/reply/ok/refundReceived").present?
    end

    private

    attr_reader :payment, :amount, :merchant_code

    def xml
      builder = Nokogiri::XML::Builder.new do |xml|
        build_doctype(xml)

        xml.paymentService(version: "1.4", merchantCode: merchant_code) do
          xml.modify do
            xml.orderModification(orderCode: payment.order_key) do
              xml.refund do
                xml.amount(value: amount, currencyCode: "GBP", exponent: 2)
              end
            end
          end
        end
      end

      builder.to_xml
    end

    def ecom_order?
      return true if merchant_code == Rails.configuration.worldpay_ecom_merchantcode

      false
    end

    def username
      return Rails.configuration.worldpay_ecom_username if ecom_order?

      Rails.configuration.worldpay_username
    end

    def password
      return Rails.configuration.worldpay_ecom_password if ecom_order?

      Rails.configuration.worldpay_password
    end
  end
end
