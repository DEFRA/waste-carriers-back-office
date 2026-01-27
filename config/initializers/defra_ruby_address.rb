# frozen_string_literal: true

DefraRuby::Address.configure do |config|
  config.host = ENV.fetch("WCRS_OSPLACES_URL", "https://api.os.uk/search/places/v1")
  config.key = ENV.fetch("WCRS_OSPLACES_KEY", nil)
end
