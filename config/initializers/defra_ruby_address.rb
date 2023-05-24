# frozen_string_literal: true

DefraRuby::Address.configure do |configuration|
  configuration.host = ENV.fetch("WCRS_OS_PLACES_DOMAIN", nil)
end
