# frozen_string_literal: true

require "defra_ruby/companies_house"

DefraRuby::CompaniesHouse.configure do |config|
  config.companies_house_host = Rails.configuration.companies_house_host
  config.companies_house_api_key = Rails.configuration.companies_house_api_key
end
