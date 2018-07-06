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
    config.time_zone = "UTC"

    # The default locale is :en and all translations from config/locales/*/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    # config.i18n.default_locale = :de

    # Enable the asset pipeline
    config.assets.enabled = true

    config.assets.precompile += %w(
      application.css
      print.css
    )

    # Don't add field_with_errors div wrapper around fields with errors
    config.action_view.field_error_proc = proc { |html_tag, _instance|
      "#{html_tag}".html_safe
    }

    # Errbit config
    config.airbrake_on = ENV["WCRS_USE_AIRBRAKE"] == "true" ? true : false
    config.airbrake_host = ENV["WCRS_AIRBRAKE_URL"]
    # Even though we may not want to enable airbrake, its initializer requires
    # a value for project ID and key else it errors.
    # Furthermore Errbit (which we send the exceptions to) doesn"t make use of
    # the project ID, but it still has to be set to a positive integer or
    # Airbrake errors. Hence we just set it to 1.
    config.airbrake_id = 1
    config.airbrake_key = ENV["WCRS_BACKOFFICE_AIRBRAKE_PROJECT_KEY"] || "dummy"

    # Companies House config
    config.companies_house_host = ENV["WCRS_COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
    config.companies_house_api_key = ENV["WCRS_COMPANIES_HOUSE_API_KEY"]

    # Paths
    config.wcrs_renewals_url = ENV["WCRS_RENEWALS_DOMAIN"] || "http://localhost:3002"
    config.wcrs_frontend_url = ENV["WCRS_FRONTEND_DOMAIN"] || "http://localhost:3000"
    config.wcrs_services_url = ENV["WCRS_SERVICES_DOMAIN"] || "http://localhost:8003"
    config.os_places_service_url = ENV["WCRS_OS_PLACES_DOMAIN"] || "http://localhost:8005"

    # Fees
    config.renewal_charge = ENV["WCRS_RENEWAL_CHARGE"].to_i
    config.type_change_charge = ENV["WCRS_TYPE_CHANGE_CHARGE"].to_i
    config.card_charge = ENV["WCRS_CARD_CHARGE"].to_i

    # Times
    config.renewal_window = ENV["WCRS_REGISTRATION_RENEWAL_WINDOW"].to_i
    config.expires_after = ENV["WCRS_REGISTRATION_EXPIRES_AFTER"].to_i

    # Worldpay
    config.worldpay_url = ENV["WCRS_WORLDPAY_URL"] || "https://secure-test.worldpay.com/jsp/merchant/xml/paymentService.jsp"
    config.worldpay_admin_code = ENV["WCRS_WORLDPAY_ADMIN_CODE"]
    config.worldpay_merchantcode = ENV["WCRS_WORLDPAY_MOTO_MERCHANTCODE"]
    config.worldpay_username =  ENV["WCRS_WORLDPAY_MOTO_USERNAME"]
    config.worldpay_password = ENV["WCRS_WORLDPAY_MOTO_PASSWORD"]
    config.worldpay_macsecret =  ENV["WCRS_WORLDPAY_MOTO_MACSECRET"]

    # Version info
    config.application_version = "0.0.1".freeze
    config.application_name = "waste-carriers-front-office"
    config.git_repository_url = "https://github.com/DEFRA/#{config.application_name}"
    config.generators do |g|
      g.orm :mongoid
    end
  end
end
