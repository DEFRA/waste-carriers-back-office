# frozen_string_literal: true

class User
  include Mongoid::Document

  # Use the User database
  store_in client: "users", collection: "back_office_users"

  devise :database_authenticatable,
         :lockable,
         :recoverable,
         :trackable,
         :validatable

  ## Confirmable
  # Any user confirmation happens in the frontend app - however we need this flag to seed confirmed users
  field :confirmed_at, type: DateTime

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  # Lockable
  field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  field :locked_at,       type: Time

  validates :password, presence: true, length: { in: 8..128 }
  validate :password_must_have_lowercase_uppercase_and_numeric

  private

  def password_must_have_lowercase_uppercase_and_numeric
    has_lowercase = (password =~ /[a-z]/)
    has_uppercase = (password =~ /[A-Z]/)
    has_numeric = (password =~ /[0-9]/)
    return true if has_lowercase && has_uppercase && has_numeric
    errors.add(:password, I18n.t("errors.messages.weakPassword"))
  end
end
