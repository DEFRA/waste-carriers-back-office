# frozen_string_literal: true

DefraRubyMocks.configure do |configuration|
  # Enable the mock routes mounted in this app if the environment is configured
  # for it
  configuration.enable = ENV["WCRS_MOCK_ENABLED"] || false
  # Set how long the mock should delay before responding. In the engine itself
  # the default is 1000ms (1 second)
  configuration.delay = ENV["WCRS_MOCK_DELAY"] || 1000

  # Tell the mocks engine details needed to mock worldpay. These are needed
  # so it can then generate values that the calling app will verify as valid
  configuration.worldpay_admin_code = ENV["WCRS_WORLDPAY_ADMIN_CODE"]
  configuration.worldpay_merchant_code = ENV["WCRS_WORLDPAY_ECOM_MERCHANTCODE"]
  configuration.worldpay_mac_secret = ENV["WCRS_WORLDPAY_ECOM_MACSECRET"]
  # Tell the mocks engine what our domain is. For the worldpay mock it needs to
  # tell a calling app what url to redirect a user to in order to 'mock' the
  # payment part of the process. But in the environments it runs in it is
  # impossible for it to determine what to use. So we simply just tell it!
  configuration.worldpay_domain = File.join(ENV["WCRS_BACK_OFFICE_DOMAIN"] || "http://localhost:8001", "/bo/mocks")
end
