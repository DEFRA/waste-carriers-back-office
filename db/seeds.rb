# frozen_string_literal: true

def find_or_create_user(email, role)
  User.find_or_create_by(
    email: email,
    role: role,
    password: ENV["WCRS_DEFAULT_PASSWORD"] || "Secret123",
    confirmed_at: Time.new(2015, 1, 1)
  )
end

def seed_users
  # Agency super
  find_or_create_user("bo-agency-super@wcr.gov.uk", "agency_super")
  # Finance super
  find_or_create_user("bo-finance-super@wcr.gov.uk", "finance_super")

  # Standard agency user
  find_or_create_user("bo-user@wcr.gov.uk", "agency")
  # Agency refund payment user
  find_or_create_user("bo-user-with-refund@wcr.gov.uk", "agency_with_refund")
  # Finance basic user
  find_or_create_user("bo-finance-user@wcr.gov.uk", "finance")
  # Finance admin user
  find_or_create_user("bo-finance-admin@wcr.gov.uk", "finance_admin")
end

# Only seed if not running in production or we specifically require it, eg. for Heroku
seed_users if !Rails.env.production? || ENV["WCR_ALLOW_SEED"]
