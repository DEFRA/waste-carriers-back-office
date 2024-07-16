# frozen_string_literal: true

module Api
  class GovpayWebhooksController < ::ApplicationController
    skip_before_action :verify_authenticity_token

    def signature
      payload = request.body.read

      signature = WasteCarriersEngine::GovpayPaymentWebhookSignatureService.run(body: payload)

      render plain: signature
    end

    private

    def skip_auth_on_this_controller?
      true
    end
  end
end
