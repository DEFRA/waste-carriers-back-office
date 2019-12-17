# frozen_string_literal: true

class User
  include Mongoid::Document
  include CanBehaveLikeUser

  # Use the User database
  store_in client: "users", collection: "back_office_users"

  field :session_token, type: String

  delegate :can?, :cannot?, to: :ability

  # Devise security improvements, used to invalidate old sessions on logout
  # Taken from https://makandracards.com/makandra/53562-devise-invalidating-all-sessions-for-a-user
  def authenticatable_salt
    "#{super}#{session_token}"
  end

  def invalidate_all_sessions!
    # Use set to avoid validation checks on other fields
    set(session_token: SecureRandom.hex)
  end

  # Roles

  ROLES = %w[agency
             agency_with_refund
             finance
             finance_admin
             agency_super
             finance_super].freeze

  field :role, type: String

  def in_agency_group?
    %w[agency agency_with_refund agency_super].include?(role)
  end

  def in_finance_group?
    %w[finance finance_admin finance_super].include?(role)
  end

  # Permissions

  def ability
    @_ability ||= Ability.new(self)
  end

  # Validations

  validates :role, inclusion: { in: ROLES }
end
