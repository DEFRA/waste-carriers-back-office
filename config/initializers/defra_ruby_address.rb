# frozen_string_literal: true

DefraRuby::Address.configure do |configuration|
  configuration.key = ENV.fetch("ADDRESS_FACADE_CLIENT_KEY", nil)
  configuration.client_id = ENV.fetch("ADDRESS_FACADE_CLIENT_ID", nil)
end
