# frozen_string_literal: true

WasteCarriersEngine.configure do |configuration|
  # Assisted digital config
  configuration.assisted_digital_email = ENV["WCRS_ASSISTED_DIGITAL_EMAIL"]

  # Companies house API config
  configuration.companies_house_api_key = ENV["WCRS_COMPANIES_HOUSE_API_KEY"]

  # We only want to alter the companies house URL if mocking is enabled. Else
  # the url is handled by the defra-ruby-validators gem from the wcr engine
  if ENV["WCRS_MOCK_ENABLED"].to_s.downcase == "true"
    configuration.companies_house_host = ENV["WCRS_MOCK_FO_COMPANIES_HOUSE_URL"]
  end

  # Link to dashboard from user journeys
  configuration.link_from_journeys_to_dashboards = true

  # Last email cache config
  configuration.use_last_email_cache = ENV["WCRS_USE_LAST_EMAIL_CACHE"] || "false"

  # Configure airbrake, which is done via the engine using defra_ruby_alert
  configuration.airbrake_enabled = ENV["WCRS_USE_AIRBRAKE"]
  configuration.airbrake_host = ENV["WCRS_AIRBRAKE_URL"]
  configuration.airbrake_project_key = ENV["WCRS_BACKOFFICE_AIRBRAKE_PROJECT_KEY"]
  configuration.airbrake_blocklist = [/password/i, /authorization/i]

  configuration.address_host = ENV["ADDRESSBASE_URL"] || "http://localhost:8005"

  # By telling the engine it is hosted in the back-office it can make decisions
  # about any changes in behaviour needed. For example, the payment confirmation
  # email from Worldpay is only applicable to users in the front-office. This is
  # because Worldpay does not send one if the merchant code is MOTO. So the
  # engine can use this flag to determine whether to show payment confirmation
  # related content
  configuration.host_is_back_office = true
end
WasteCarriersEngine.start_airbrake
