# frozen_string_literal: true

module Api
  class GovpayWebhooksController < ::ApplicationController
    skip_before_action :verify_authenticity_token

    def signatures
      payload = request.body.read

      signatures = DefraRubyGovpay::WebhookSignatureService.run(body: payload)

      render json: signatures
    end

    private

    def skip_auth_on_this_controller?
      true
    end
  end
end
