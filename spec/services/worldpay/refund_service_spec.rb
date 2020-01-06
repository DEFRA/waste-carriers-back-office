# frozen_string_literal: true

module Worldpay
  RSpec.describe RefundService do
    let(:payment) { double(:payment) }
    let(:result) { described_class.run(payment: payment) }

    describe ".run" do
      context "when the payment is not a worldpay payment nor a worldpay_missed payment" do
        it "returns nil" do
          expect(payment).to receive(:worldpay?).and_return(false)
          expect(payment).to receive(:worldpay_missed?).and_return(false)

          expect(result).to be_nil
        end
      end

      context "when the payment is a worldpay payment" do
        before do
          expect(payment).to receive(:worldpay?).and_return(true)
          expect(payment).to receive(:amount).and_return(100)
          expect(payment).to receive(:order_key).and_return("foo")
        end

        context "when the response from worldpay contains the correct information" do
          it "returns true" do
            expect(RestClient::Request).to receive(:execute).and_return(
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
