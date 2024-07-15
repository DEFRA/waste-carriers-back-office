# frozen_string_literal: true

module Api
  class GovpayWebhooksController < ::ApplicationController
    skip_before_action :verify_authenticity_token

    def signature
      payload = request.body.read

      signature = hmac_digest(payload)

      render plain: signature
    end

    private

    def webhook_signing_secret
      @webhook_signing_secret = ENV.fetch("WCRS_GOVPAY_CALLBACK_WEBHOOK_SIGNING_SECRET")
    end

    def hmac_digest(body)
      digest = OpenSSL::Digest.new("sha256")
      OpenSSL::HMAC.hexdigest(digest, webhook_signing_secret, body)
    end

    def skip_auth_on_this_controller?
      true
    end
  end
end
