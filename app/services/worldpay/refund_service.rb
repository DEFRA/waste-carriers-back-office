# frozen_string_literal: true

module Worldpay
  class RefundService < ::WasteCarriersEngine::BaseService
    # include ::WasteCarriersEngine::CanSendWorldpayRequest
    # include ::WasteCarriersEngine::CanBuildWorldpayXml

    def run(payment:)
      return unless payment.worldpay? || payment.worldpay_missed?

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

    def build_doctype(xml)
        xml.doc.create_internal_subset(
          "paymentService",
          "-//WorldPay/DTD WorldPay PaymentService v1/EN",
          "http://dtd.worldpay.com/paymentService_v1.dtd"
        )
      end

      def merchant_code
        @_merchant_code ||= Rails.configuration.worldpay_merchantcode
      end
    def send_request(xml)
        Rails.logger.debug "Sending initial request to WorldPay: #{xml}"

        # begin
          response = RestClient::Request.execute(
            method: :get,
            url: url,
            payload: xml,
            headers: {
              "Authorization" => authorization
            }
          )

          Rails.logger.debug "Received response from WorldPay: #{response}"

          response
        # end
      end

      def url
        @_url ||= Rails.configuration.worldpay_url
      end

      def authorization
        @_authorization ||= "Basic " + Base64.encode64(username + ":" + password).to_s
      end

      def username
        @_username ||= Rails.configuration.worldpay_username
      end

      def password
        @_password ||= Rails.configuration.worldpay_password
      end

  end
end
