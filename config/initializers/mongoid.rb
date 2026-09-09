# frozen_string_literal: true

# Pin Mongoid's behaviour flags to their 9.1 values
Mongoid.configure do |config|
  config.load_defaults 9.1
end
