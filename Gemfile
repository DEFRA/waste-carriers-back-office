# frozen_string_literal: true

source "https://rubygems.org"
ruby "3.2.2"

# Use MongoDB as the database, and mongoid as our ORM for it.
gem "mongoid"

gem "mongo_session_store"

# Use SCSS for stylesheets
gem "sass-rails", "~> 6.0"
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier"

# Use CanCanCan for user roles and permissions
gem "cancancan"

gem "defra_ruby_template", "~> 5.11"

# Use Devise for user authentication
gem "devise"
gem "devise_invitable"

# To support method: :patch requests
gem "jquery-rails"

# Manage, create and open zip files https://github.com/rubyzip/rubyzip
gem "rubyzip"

gem "secure_headers"

# Design system form builder
gem "govuk_design_system_formbuilder", "~> 5.3"

gem "kaminari"
gem "kaminari-mongoid"

# Use Whenever to manage cron tasks
gem "whenever", require: false

gem "wicked_pdf"

gem "matrix", "< 0.4.3"

gem "net-imap"

gem "defra_ruby_area"

gem "defra_ruby_storm"

# Use the Defra Ruby Aws gem for loading files to AWS buckets
gem "defra_ruby_aws"

# Use the waste carriers engine for the user journey
gem "waste_carriers_engine",
    git: "https://github.com/DEFRA/waste-carriers-engine",
    branch: "main"

# Use the Defra Ruby Features gem to allow users with the correct permissions to
# manage feature toggle (create / update / delete) from the back-office.
gem "defra_ruby_features"

# Use the defra ruby mocks engine to add support for mocking external services
# in live environment. Essentially with this gem added and enabled the app
# also becomes a 'mock' for external services like companies house.
# This then allows us to performance test our services without fear of being
# reported for causing undue loads on the external services we use.
# With the environment properly configured, when any app in an environment needs
# to call Companies House, instead it will call this app which will mock the end
# point and return the response expected.
gem "defra_ruby_mocks"

# Allows us to automatically generate the change log from the tags, issues,
# labels and pull requests on GitHub. Added as a dependency so all dev's have
# access to it to generate a log, and so they are using the same version.
# New dev's should first create GitHub personal app token and add it to their
# ~/.bash_profile (or equivalent)
# https://github.com/skywinder/github-changelog-generator#github-token
# Then simply run `bundle exec rake changelog` to update CHANGELOG.md
# Should be in the :development group however when it is it breaks deployment
# to Heroku. Hence moved outside group till we can understand why.
gem "github_changelog_generator", require: false

# Defines a route for ELB healthchecks. The healthcheck is a piece of Rack
# middleware that does absolutely nothing, so it is faster than just using the
# default `/` route, or `/version` as was previously used.
# The app now returns a 200 from `/healthcheck`
# Test with `curl -I http://localhost:8001/healthcheck`
gem "aws-healthcheck"

# dev and test don't really need passenger but we use it anyway for consistency
# across environments, as there have been instances where issues didn't emerge
# until deployment to a production environment:
gem "passenger", "~> 6.0", require: "phusion_passenger/rack_handler"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "pry-byebug"
  # Apply our style guide to ensure consistency in how the code is written
  gem "defra_ruby_style"
  # Shim to load environment variables from a .env file into ENV in development
  # and test
  gem "dotenv-rails"
  # Project uses RSpec as its test framework
  gem "rspec-rails"
  gem "rubocop-capybara", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "database_cleaner-mongoid"
  gem "factory_bot_rails"
  gem "faker"
  gem "faraday-retry"
  gem "rails-controller-testing"
  gem "rspec-retry"
  gem "timecop"

  # Generates a test coverage report on every `bundle exec rspec` call. We use
  # the output to feed SonarCloud's stats and analysis
  gem "simplecov", "~> 0.22.0", require: false

  # Allow automated testing of the whenever schedule
  gem "whenever-test", "~> 1.0"

  # Mocking HTTP requests
  gem "vcr"
  gem "webmock", "~> 3.4"
end
