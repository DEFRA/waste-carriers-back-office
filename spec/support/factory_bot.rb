# frozen_string_literal: true

# Require this here to get factories to play nice with engine
require "factory_bot_rails"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
