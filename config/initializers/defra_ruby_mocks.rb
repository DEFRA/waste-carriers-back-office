# frozen_string_literal: true

DefraRubyMocks.configure do |configuration|
  # Enable the mock routes mounted in this app if the environment is configured
  # for it
  configuration.enable = ENV["WCRS_MOCK_ENABLED"] || false
  # Set how long the mock should delay before responding. In the engine itself
  # the default is 1000ms (1 second)
  configuration.delay = ENV["WCRS_MOCK_DELAY"] || 1000
end
