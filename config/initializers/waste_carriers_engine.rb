# frozen_string_literal: true

WasteCarriersEngine.configure do |configuration|
  # Companies house API config
  configuration.companies_house_api_key = ENV["WCRS_COMPANIES_HOUSE_API_KEY"]

  # We only want to alter the companies house URL if mocking is enabled. Else
  # the url is handled by the defra-ruby-validators gem from the wcr engine
  if ENV["WCRS_MOCK_ENABLED"].to_s.downcase == "true"
    configuration.companies_house_host = ENV["WCRS_MOCK_FO_COMPANIES_HOUSE_URL"]
  end
end
