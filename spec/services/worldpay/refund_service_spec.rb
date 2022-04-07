# frozen_string_literal: true

module Worldpay
  RSpec.describe RefundService do
    let(:payment) { double(:payment) }
    let(:merchant_code) { "merchant_code" }
    let(:result) { described_class.run(payment: payment, amount: 100, merchant_code: merchant_code) }

    describe ".run" do
      context "when the payment is not a worldpay payment nor a worldpay_missed payment" do
        it "returns false" do
          expect(payment).to receive(:online?).and_return(false)
          expect(payment).to receive(:online_missed?).and_return(false)

          expect(result).to be_falsey
        end
      end

      context "when the payment is a worldpay payment" do
        let(:worldpay_ecom_merchantcode) { "worldpay_ecom_merchantcode" }
        let(:worldpay_merchantcode) { "worldpay_merchantcode" }
        let(:worldpay_ecom_username) { "worldpay_ecom_username" }
        let(:worldpay_username) { "worldpay_username" }
        let(:worldpay_ecom_password) { "worldpay_ecom_password" }
        let(:worldpay_password) { "worldpay_password" }
        let(:worldpay_url) { "worldpay_url" }

        before do
          allow(payment).to receive(:online?).and_return(true)
          allow(payment).to receive(:order_key).and_return("foo")

          allow(Rails.configuration).to receive(:worldpay_ecom_merchantcode).and_return(worldpay_ecom_merchantcode)
          allow(Rails.configuration).to receive(:worldpay_merchantcode).and_return(worldpay_merchantcode)
          allow(Rails.configuration).to receive(:worldpay_ecom_username).and_return(worldpay_ecom_username)
          allow(Rails.configuration).to receive(:worldpay_username).and_return(worldpay_username)
          allow(Rails.configuration).to receive(:worldpay_ecom_password).and_return(worldpay_ecom_password)
          allow(Rails.configuration).to receive(:worldpay_password).and_return(worldpay_password)
          allow(Rails.configuration).to receive(:worldpay_url).and_return(worldpay_url)
        end

        context "when the merchant code is an ecom" do
          let(:merchant_code) { "worldpay_ecom_merchantcode" }

          it "sends a request using ecom merchant code, user name and password" do
            request_headers = {
              "Authorization" => "Basic #{Base64.encode64('worldpay_ecom_username:worldpay_ecom_password')}"
            }

            expect(RestClient::Request).to receive(:execute).with(hash_including(headers: request_headers))

            result
          end
        end

        context "when the response from worldpay contains the correct information" do
          it "returns true" do
            request_headers = {
              "Authorization" => "Basic " + Base64.encode64("worldpay_username:worldpay_password").to_s
            }

            expect(RestClient::Request).to receive(:execute).with(hash_including(headers: request_headers)).and_return(
              <<-XML
                <?xml version=\"1.0\" encoding=\"UTF-8\"?>
                <!DOCTYPE paymentService PUBLIC \"-//WorldPay//DTD WorldPay PaymentService v1//EN\" \"http://dtd.worldpay.com/paymentService_v1.dtd\">
                <paymentService version=\"1.4\" merchantCode=\"EASERRSIMMOTO\">
                  <reply>
                    <ok>
                      <refundReceived orderCode=\"\">
                        <amount value=\"100\" currencyCode=\"GBP\" exponent=\"2\" debitCreditIndicator=\"credit\"/>
                      </refundReceived>
                    </ok>
                  </reply>
                </paymentService>
              XML
            )

            expect(result).to be_truthy
          end
        end

        context "when the response from worldpay does not contain the correct information" do
          it "returns false" do
            expect(RestClient::Request).to receive(:execute).and_return(
              <<-XML
                <?xml version=\"1.0\" encoding=\"UTF-8\"?>
                <!DOCTYPE paymentService PUBLIC \"-//WorldPay//DTD WorldPay PaymentService v1//EN\" \"http://dtd.worldpay.com/paymentService_v1.dtd\">
                <paymentService version=\"1.4\" merchantCode=\"EASERRSIMMOTO\"></paymentService>
              XML
            )

            expect(result).to be_falsey
          end
        end
      end
    end
  end
end
