# frozen_string_literal: true

# Require this to support automatically cleaning the database when testing
require "database_cleaner-mongoid"

RSpec.configure do |config|
  # Clean the registrations and users databases before running tests
  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :deletion
    DatabaseCleaner[:mongoid, { db: :users }].strategy = :deletion

    DatabaseCleaner.clean
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
