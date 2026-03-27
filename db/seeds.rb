# frozen_string_literal: true

def find_or_create_user(email, role)
  User.find_or_create_by(
    email: email,
    role: role,
    password: ENV["WCRS_DEFAULT_PASSWORD"] || "V1ctori@sSecr3t",
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

# rubocop:disable Rails/Output
def seed_convictions
  puts "Seeding convictions data..."

  seeds = JSON.parse(Rails.root.join("db/seeds/convictions.json").read)
  convictions_data = seeds["convictions"]

  WasteCarriersEngine::ConvictionsCheck::Entity.delete_all
  convictions_data.each do |data|
    data["date_of_birth"] = Date.parse(data["date_of_birth"]) if data["date_of_birth"]
    WasteCarriersEngine::ConvictionsCheck::Entity.create!(data.symbolize_keys)
  end

  puts "Seeded #{WasteCarriersEngine::ConvictionsCheck::Entity.count} conviction records"
end
# rubocop:enable Rails/Output

seed_convictions if !Rails.env.production? || ENV["WCR_ALLOW_SEED"]
