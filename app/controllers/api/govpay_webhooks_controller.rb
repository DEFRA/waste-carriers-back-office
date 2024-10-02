# frozen_string_literal: true

module Api
  class GovpayWebhooksController < ::ApplicationController
    skip_before_action :verify_authenticity_token

    def signatures
      payload = request.body.read

      signatures = WasteCarriersEngine::GovpayPaymentWebhookSignatureService.run(body: payload)

      render json: signatures
    end

    private

    def skip_auth_on_this_controller?
      true
    end
  end
end
