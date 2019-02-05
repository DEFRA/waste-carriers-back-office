# frozen_string_literal: true

# Require this to support automatically cleaning the database when testing
require "database_cleaner"

RSpec.configure do |config|
  # Clean the registrations and users databases before running tests
  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid, { connection: :users }].strategy = :truncation

    DatabaseCleaner.clean
  end
end
