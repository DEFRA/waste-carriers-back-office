require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EntityMatchingService
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Errbit config - If you are confused why we say this is Errbit config then
    # name everything Airbrake, its because Airbrake (the company) set the
    # API specification and provide the gem, but we choose instead to send
    # notifications to an instance of Errbit we manage ourselves
    # (cause its free!)
    config.airbrake_on = ENV["WCRS_USE_AIRBRAKE"] == "true" ? true : false
    config.airbrake_host = ENV["WCRS_AIRBRAKE_URL"]
    # Even though we may not want to enable airbrake, its initializer requires
    # a value for project ID and key else it errors.
    # Furthermore Errbit (which we send the exceptions to) doesn't make use of
    # the project ID, but it still has to be set to a positive integer or
    # Airbrake errors. Hence we just set it to 1.
    config.airbrake_id = 1
    config.airbrake_key = ENV["WCRS_BACKOFFICE_AIRBRAKE_PROJECT_KEY"] || "dummy"

    config.generators do |g|
      g.orm :mongoid
    end

    # Enable the asset pipeline
    config.assets.enabled = true

    config.assets.precompile += %w(
      application.css
      print.css
    )
  end
end
