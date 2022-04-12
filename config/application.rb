# frozen_string_literal: true

require File.expand_path("boot", __dir__)

require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

require "defra_ruby_features"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WasteCarriersBackOffice
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Mongoid logging level to INFO. We have found mongoid to ber overly
    # chatty in the logs.
    Mongoid.logger.level = Logger::INFO

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "UTC"

    # The default locale is :en and all translations from config/locales/*/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    # config.i18n.default_locale = :de

    config.autoload_paths << "#{config.root}/app/forms/concerns"
    config.autoload_paths << "#{config.root}/app/lib"

    # Enable the asset pipeline
    config.assets.enabled = true

    config.assets.precompile += %w[
      application.css
      print.css
    ]

    # Don't add field_with_errors div wrapper around fields with errors
    config.action_view.field_error_proc = proc { |html_tag, _instance|
      html_tag.to_s.html_safe
    }

    # Errbit config
    config.airbrake_on = ENV["WCRS_USE_AIRBRAKE"] == "true"
    config.airbrake_host = ENV["WCRS_AIRBRAKE_URL"]
    # Even though we may not want to enable airbrake, its initializer requires
    # a value for project ID and key else it errors.
    # Furthermore Errbit (which we send the exceptions to) doesn"t make use of
    # the project ID, but it still has to be set to a positive integer or
    # Airbrake errors. Hence we just set it to 1.
    config.airbrake_id = 1
    config.airbrake_key = ENV["WCRS_BACKOFFICE_AIRBRAKE_PROJECT_KEY"] || "dummy"

    # Data export config
    config.epr_reports_bucket_name = ENV["AWS_DAILY_EXPORT_BUCKET"]
    config.epr_export_filename = ENV["EPR_DAILY_REPORT_FILE_NAME"] || "waste_carriers_epr_daily_full"
    config.boxi_exports_bucket_name = ENV["AWS_BOXI_EXPORT_BUCKET"]
    config.boxi_exports_filename = ENV["BOXI_EXPORTS_FILENAME"] || "waste_carriers_boxi_daily_full"
    config.weekly_exports_bucket_name = ENV["AWS_WEEKLY_EXPORT_BUCKET"]
    config.card_orders_export_filename = ENV["CARD_ORDERS_EXPORT_FILENAME"] || "card_orders"

    # Data retention
    config.data_retention_years = ENV["DATA_RETENTION_YEARS"] || 7

    # Companies House config
    config.companies_house_api_key = ENV["WCRS_COMPANIES_HOUSE_API_KEY"]

    config.companies_house_host =
      if ENV["WCRS_MOCK_ENABLED"].to_s.downcase == "true"
        ENV["WCRS_MOCK_FO_COMPANIES_HOUSE_URL"]
      else
        ENV["WCRS_COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
      end

    # Paths
    config.wcrs_renewals_url = ENV["WCRS_RENEWALS_DOMAIN"] || "http://localhost:3002"
    config.wcrs_frontend_url = ENV["WCRS_FRONTEND_DOMAIN"] || "http://localhost:3000"
    config.wcrs_backend_url = ENV["WCRS_FRONTEND_ADMIN_DOMAIN"] || "http://localhost:3000"
    config.wcrs_back_office_url = ENV["WCRS_BACK_OFFICE_DOMAIN"] || "http://localhost:8001"
    config.wcrs_services_url = ENV["WCRS_SERVICES_DOMAIN"] || "http://localhost:8003"
    config.os_places_service_url = ENV["WCRS_OS_PLACES_DOMAIN"] || "http://localhost:8005"
    config.host = config.wcrs_back_office_url

    # Finance
    config.write_off_agency_user_cap = ENV["WRITE_OFF_AGENCY_USER_CAP"] || "500"

    # Fees
    config.renewal_charge = ENV["WCRS_RENEWAL_CHARGE"].to_i
    config.new_registration_charge = ENV["WCRS_REGISTRATION_CHARGE"].to_i
    config.type_change_charge = ENV["WCRS_TYPE_CHANGE_CHARGE"].to_i
    config.card_charge = ENV["WCRS_CARD_CHARGE"].to_i

    # Times
    config.renewal_window = ENV["WCRS_REGISTRATION_RENEWAL_WINDOW"].to_i
    config.expires_after = ENV["WCRS_REGISTRATION_EXPIRES_AFTER"].to_i
    config.covid_grace_window = ENV["WCRS_REGISTRATION_COVID_GRACE_WINDOW"].to_i
    config.grace_window = ENV["WCRS_REGISTRATION_GRACE_WINDOW"].to_i
    config.end_of_covid_extension = Date.new(ENV["WCRS_END_OF_COVID_EXTENSION_YEAR"].to_i,
                                             ENV["WCRS_END_OF_COVID_EXTENSION_MONTH"].to_i,
                                             ENV["WCRS_END_OF_COVID_EXTENSION_DAY"].to_i)

    # Worldpay
    config.worldpay_url = if ENV["WCRS_MOCK_ENABLED"].to_s.downcase == "true"
                            ENV["WCRS_MOCK_FO_WORLDPAY_URL"]
                          else
                            ENV["WCRS_WORLDPAY_URL"] || "https://secure-test.worldpay.com/jsp/merchant/xml/paymentService.jsp"
                          end
    config.worldpay_url = ENV["WCRS_WORLDPAY_URL"] || "https://secure-test.worldpay.com/jsp/merchant/xml/paymentService.jsp"
    config.worldpay_admin_code = ENV["WCRS_WORLDPAY_ADMIN_CODE"]
    config.worldpay_merchantcode = ENV["WCRS_WORLDPAY_MOTO_MERCHANTCODE"]
    config.worldpay_ecom_merchantcode = ENV["WCRS_WORLDPAY_ECOM_MERCHANTCODE"]
    config.worldpay_username = ENV["WCRS_WORLDPAY_MOTO_USERNAME"]
    config.worldpay_password = ENV["WCRS_WORLDPAY_MOTO_PASSWORD"]
    config.worldpay_ecom_username = ENV["WCRS_WORLDPAY_ECOM_USERNAME"]
    config.worldpay_ecom_password = ENV["WCRS_WORLDPAY_ECOM_PASSWORD"]
    config.worldpay_macsecret = ENV["WCRS_WORLDPAY_MOTO_MACSECRET"]

    # Emails
    config.email_service_name = "Waste Carriers Registration Service"
    config.email_service_email = ENV["WCRS_EMAIL_SERVICE_EMAIL"]
    config.email_test_address = ENV["WCRS_EMAIL_TEST_ADDRESS"]
    config.first_renewal_email_reminder_days = ENV["FIRST_RENEWAL_EMAIL_REMINDER_DAYS"] || 42
    config.second_renewal_email_reminder_days = ENV["SECOND_RENEWAL_EMAIL_REMINDER_DAYS"] || 28

    # Letters exports
    config.digital_reminder_letters_exports_expires_in = ENV["DIGITAL_REMINDER_LETTERS_EXPORTS_EXPIRES_IN"] || 21
    config.digital_reminder_letters_delete_records_in = ENV["DIGITAL_REMINDER_LETTERS_DELETE_RECORDS_IN"] || 28
    config.ad_reminder_letters_exports_expires_in = ENV["AD_REMINDER_LETTERS_EXPORTS_EXPIRES_IN"] || 35
    config.ad_reminder_letters_delete_records_in = ENV["AD_REMINDER_LETTERS_DELETE_RECORDS_IN"] || 28

    # Digital or assisted digital metaData.route value
    config.metadata_route = "ASSISTED_DIGITAL"

    # Database cleanup
    config.max_transient_registration_age_days = ENV["MAX_TRANSIENT_REGISTRATION_AGE_DAYS"] || 30

    # Version info
    config.application_version = "0.0.1"
    config.application_name = "waste-carriers-back-office"
    config.git_repository_url = "https://github.com/DEFRA/#{config.application_name}"
    config.generators do |g|
      g.orm :mongoid
    end
  end
end
