# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.4.2"

# Use Airbrake for error reporting to Errbit
# Version 6 and above cause errors with Errbit, so use 5.8.1 for now
gem "airbrake", "5.8.1"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.1.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"
# Use jquery as the JavaScript library
gem "jquery-rails"
# Use MongoDB as the database, and mongoid as our ORM for it. This version of
# mongoid supports MongoDb 3.6
gem "mongoid", "~> 5.2.0"
# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "4.2.10"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 0.4.0", group: :doc

# Use Devise for user authentication
# gem "devise", ">= 4.4.3"
gem "devise_invitable", "~> 1.7.0"

# Use GOV.UK Admin Template for styling
gem "govuk_admin_template", "~> 6.6"

# Sticking with version 3 for now as 4 doesn't support Rails 4
gem "simple_form", "~> 3.5.1"

# Web application server that replaces webrick. It handles HTTP requests,
# manages processes and resources, and enables administration, monitoring
# and problem diagnosis. It is used in production because it gives us an ability
# to scale by creating additional processes, and will automatically restart any
# that fail.
gem "passenger", "~> 5.0", ">= 5.0.30", require: "phusion_passenger/rack_handler"

# Use the waste carriers engine for the user journey
gem "waste_carriers_engine",
    git: "https://github.com/DEFRA/waste-carriers-renewals"

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

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug"
  # Shim to load environment variables from a .env file into ENV in development
  # and test
  gem "dotenv-rails"
  # Project uses RSpec as its test framework
  gem "rspec-rails", "~> 3.6"
  # Rubocop to ensure consistency in how the code is written
  gem "rubocop"
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 2.0"
end

group :test do
  gem "database_cleaner"
  gem "factory_bot_rails"
  # Generates a test coverage report on every `bundle exec rspec` call. We use
  # the output to feed CodeClimate's stats and analysis
  gem "simplecov", require: false
end
