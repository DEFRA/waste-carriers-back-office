# frozen_string_literal: true

DefraRubyMocks.configure do |configuration|
  # Enable the mock routes mounted in this app if the environment is configured
  # for it
  configuration.enable = ENV["WCRS_MOCK_ENABLED"] || false

  # Set how long the mock should delay before responding. In the engine itself
  # the default is 1000ms (1 second)
  configuration.delay = ENV["WCRS_MOCK_DELAY"] || 1000

  # Govpay API mock details. Note FO application point to BO mocks and vice-versa by defafult
  # so they don't block in a single-process application (e.g. local vagrant).
  configuration.govpay_mocks_external_root_url = ENV.fetch("WCRS_MOCK_BO_GOVPAY_URL", "http://localhost:3002/fo/mocks/govpay/v1")
  configuration.govpay_mocks_external_root_url_other = ENV.fetch("WCRS_MOCK_FO_GOVPAY_URL", "http://localhost:8001/bo/mocks/govpay/v1")

  # On our hosted environments, the FO/BOmocks are accessible to each other via different URLs:
  configuration.govpay_mocks_internal_root_url = ENV.fetch("WCRS_MOCK_BO_GOVPAY_URL_INTERNAL", "http://localhost:3002/fo/mocks/govpay/v1")
  configuration.govpay_mocks_internal_root_url_other = ENV.fetch("WCRS_MOCK_FO_GOVPAY_URL_INTERNAL", "http://localhost:8001/bo/mocks/govpay/v1")
end
