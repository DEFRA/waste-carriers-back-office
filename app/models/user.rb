# frozen_string_literal: true

class User
  include Mongoid::Document
  include CanBehaveLikeUser

  # Use the User database
  store_in client: "users", collection: "back_office_users"

  # Devise security improvements, used to invalidate old sessions on logout
  # Taken from https://makandracards.com/makandra/53562-devise-invalidating-all-sessions-for-a-user
  field :session_token, type: String

  def authenticatable_salt
    "#{super}#{session_token}"
  end

  def invalidate_all_sessions!
    self.session_token = SecureRandom.hex
  end

  # Roles

  ROLES = %w[agency
             agency_with_refund
             finance
             finance_admin
             agency_super
             finance_super].freeze

  field :role, type: String

  # Validations

  validates :role, inclusion: { in: ROLES }
end
