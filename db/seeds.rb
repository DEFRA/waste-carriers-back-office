# frozen_string_literal: true

User.find_or_create_by(
  email: "bo-user@waste-exemplar.gov.uk",
  password: ENV["WCRS_DEFAULT_PASSWORD"] || "Secret123",
  confirmed_at: Time.new(2015, 1, 1)
)
