# frozen_string_literal: true

WasteCarriersEngine.configure do |configuration|
  # Companies house API config
  configuration.companies_house_api_key = ENV["WCRS_COMPANIES_HOUSE_API_KEY"]

  # We only want to alter the companies house URL if mocking is enabled. Else
  # the url is handled by the defra-ruby-validators gem from the wcr engine
  if ENV["WCRS_MOCK_ENABLED"].to_s.downcase == "true"
    configuration.companies_house_host = ENV["WCRS_MOCK_FO_COMPANIES_HOUSE_URL"]
  end

  # Configure airbrake, which is done via the engine using defra_ruby_alert
  configuration.airbrake_enabled = ENV["WCRS_USE_AIRBRAKE"]
  configuration.airbrake_host = ENV["WCRS_AIRBRAKE_URL"]
  configuration.airbrake_project_key = ENV["WCRS_BACKOFFICE_AIRBRAKE_PROJECT_KEY"]
  configuration.airbrake_blacklist = [/password/i, /authorization/i]
end
WasteCarriersEngine.start_airbrake
