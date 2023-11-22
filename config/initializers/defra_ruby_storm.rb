# frozen_string_literal: true

require "defra_ruby/storm"

DefraRuby::Storm.configure do |config|
  config.storm_api_username = ENV.fetch("STORM_API_USERNAME", nil)
  config.storm_api_password = ENV.fetch("STORM_API_PASSWORD", nil)
end
