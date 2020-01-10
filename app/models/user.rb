# frozen_string_literal: true

class User
  include Mongoid::Document
  include CanBehaveLikeUser

  # Use the User database
  store_in client: "users", collection: "back_office_users"

  field :active, type: Boolean, default: true
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

  def active?
    active == true || active.nil?
  end

  def activate!
    update_attribute(:active, true)
  end

  def deactivate!
    update_attribute(:active, false)
  end

  # Roles

  AGENCY_ROLES = %w[agency
                    agency_with_refund
                    agency_super].freeze

  FINANCE_ROLES = %w[finance
                     finance_admin
                     finance_super].freeze

  ROLES = (AGENCY_ROLES + FINANCE_ROLES).freeze

  field :role, type: String

  def in_agency_group?
    AGENCY_ROLES.include?(role)
  end

  def in_finance_group?
    FINANCE_ROLES.include?(role)
  end

  def change_role(new_role)
    update(role: new_role)
  end

  # Permissions

  def ability
    @_ability ||= Ability.new(self)
  end

  # Validations

  validates :role, inclusion: { in: ROLES }
end
