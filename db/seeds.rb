# frozen_string_literal: true

def find_or_create_user(email, role)
  User.find_or_create_by(
    email: email,
    role: role,
    password: ENV["WCRS_DEFAULT_PASSWORD"] || "Secret123",
    confirmed_at: Time.zone.local(2015, 1, 1)
  )
end

def seed_users
  seeds = JSON.parse(Rails.root.join("db/seeds/users.json").read)
  users = seeds["users"]

  users.each do |user|
    find_or_create_user(user["email"], user["role"])
  end
end

# Only seed if not running in production or we specifically require it, eg. for Heroku
seed_users if !Rails.env.production? || ENV["WCR_ALLOW_SEED"]
