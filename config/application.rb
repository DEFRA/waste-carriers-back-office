# frozen_string_literal: true

require File.expand_path("boot", __dir__)

require "logger"
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

    # Set Mongoid logging level to WARN. We have found mongoid to be overly
    # chatty in the logs.
    Mongoid.logger.level = Logger::WARN

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "UTC"

    # The default locale is :en and all translations from config/locales/*/*.rb,yml are auto loaded.
    config.i18n.load_path += Rails.root.glob("config/locales/**/*.{rb,yml}")
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
      html_tag.to_s
    }

    # Errbit config
    config.airbrake_on = ENV["WCRS_USE_AIRBRAKE"] == "true"
    config.airbrake_host = ENV.fetch("WCRS_AIRBRAKE_URL", nil)
    # Even though we may not want to enable airbrake, its initializer requires
    # a value for project ID and key else it errors.
    # Furthermore Errbit (which we send the exceptions to) doesn"t make use of
    # the project ID, but it still has to be set to a positive integer or
    # Airbrake errors. Hence we just set it to 1.
    config.airbrake_id = 1
    config.airbrake_key = ENV["WCRS_BACKOFFICE_AIRBRAKE_PROJECT_KEY"] || "dummy"

    # Data export config
    config.epr_reports_bucket_name = ENV.fetch("AWS_DAILY_EXPORT_BUCKET", nil)
    config.epr_export_filename = ENV.fetch("EPR_DAILY_REPORT_FILE_NAME", "waste_carriers_epr_daily_full")
    config.boxi_exports_bucket_name = ENV.fetch("AWS_BOXI_EXPORT_BUCKET", nil)
    config.boxi_exports_filename = ENV.fetch("BOXI_EXPORTS_FILENAME", "waste_carriers_boxi_daily_full")
    config.weekly_exports_bucket_name = ENV.fetch("AWS_WEEKLY_EXPORT_BUCKET", nil)
    config.card_orders_export_filename = ENV.fetch("CARD_ORDERS_EXPORT_FILENAME", "card_orders")
    config.finance_report_filename_prefix = ENV.fetch("FINANCE_REPORT_FILENAME_PREFIX", "finance_stats_")
    config.finance_reports_bucket_name = ENV.fetch("FINANCE_REPORTS_BUCKET", nil)
    config.finance_reports_directory = ENV.fetch("FINANCE_REPORTS", "FINANCE_REPORTS")
    config.email_exports_bucket_name = ENV.fetch("AWS_EMAIL_EXPORT_BUCKET", nil)
    config.email_exports_directory = ENV.fetch("EMAIL_EXPORTS_DIRECTORY", "EMAIL_EXPORTS")

    # Data retention
    config.data_retention_years = ENV["DATA_RETENTION_YEARS"] || 7

    # Companies House config
    config.companies_house_api_key = ENV.fetch("WCRS_COMPANIES_HOUSE_API_KEY", nil)

    config.companies_house_host =
      if ENV["WCRS_MOCK_ENABLED"].to_s.downcase == "true"
        ENV.fetch("WCRS_MOCK_FO_COMPANIES_HOUSE_URL", nil)
      else
        ENV["WCRS_COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/"
      end

    # Paths
    # This is the domain to use on URLs for FO services such as renewal and deregistration
    config.wcrs_fo_link_domain = ENV["WCRS_RENEWALS_DOMAIN"] || "http://localhost:3002"

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
    config.grace_window = ENV["WCRS_REGISTRATION_GRACE_WINDOW"].to_i

    # Govpay
    config.govpay_url = if ENV["WCRS_MOCK_ENABLED"].to_s.downcase == "true"
                          ENV.fetch("WCRS_MOCK_BO_GOVPAY_URL", nil)
                        else
                          ENV["WCRS_GOVPAY_URL"] || "https://publicapi.payments.service.gov.uk/v1"
                        end
    config.govpay_back_office_api_token = ENV.fetch("WCRS_GOVPAY_BACK_OFFICE_API_TOKEN", nil)
    config.govpay_front_office_api_token = ENV.fetch("WCRS_GOVPAY_FRONT_OFFICE_API_TOKEN", nil)

    # Emails
    config.email_service_name = "Waste Carriers Registration Service"
    config.email_service_email = ENV.fetch("WCRS_EMAIL_SERVICE_EMAIL", nil)
    config.email_test_address = ENV.fetch("WCRS_EMAIL_TEST_ADDRESS", nil)
    config.first_renewal_email_reminder_days = ENV["FIRST_RENEWAL_EMAIL_REMINDER_DAYS"] || 42
    config.second_renewal_email_reminder_days = ENV["SECOND_RENEWAL_EMAIL_REMINDER_DAYS"] || 28

    # Letters exports
    config.digital_reminder_notifications_exports_expires_in = ENV["DIGITAL_REMINDER_LETTERS_EXPORTS_EXPIRES_IN"] || 21
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

    config.area_lookup_run_for = ENV["AREA_LOOKUP_RUN_FOR"] || 60
    config.lookups_update_address_limit = ENV["LOOKUPS_UPDATE_ADDRESS_LIMIT"] || 50

    # prevent comments showing ruby version:
    config.sass.line_comments = false

    # avoid "calc(0px) is not a number for `max`" errors under sass-rails v6:
    # https://github.com/alphagov/govuk-frontend/issues/1350#issuecomment-493129270
    config.assets.css_compressor = nil
    config.sass.style = :compressed

    # Logger
    config.wcrs_logger_max_files = ENV.fetch("WCRS_LOGGER_MAX_FILES", 3).to_i
    config.wcrs_logger_max_filesize = ENV.fetch("WCRS_LOGGER_MAX_FILESIZE", 10_000_000).to_i
    config.wcrs_logger_heartbeat_path = ENV.fetch("wcrs_logger_heartbeat_path", "/pages/heartbeat")

    config.logger = Logger.new(
      Rails.root.join("log/#{Rails.env}.log"),
      Rails.application.config.wcrs_logger_max_files,
      Rails.application.config.wcrs_logger_max_filesize
    )
  end
end
