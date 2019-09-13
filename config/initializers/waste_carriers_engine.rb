# frozen_string_literal: true

WasteCarriersEngine.configure do |configuration|
  # Companies house API config
  configuration.companies_house_api_key = ENV["WCRS_COMPANIES_HOUSE_API_KEY"]
end
