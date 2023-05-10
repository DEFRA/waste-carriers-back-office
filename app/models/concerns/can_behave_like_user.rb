# frozen_string_literal: true

module CanBehaveLikeUser
  extend ActiveSupport::Concern
  SUBSTITUTIONS = {
    "0" => "o", "1" => "i", "3" => "e", "4" => "a", "5" => "s", "7" => "t",
    "8" => "b", "9" => "g", "2" => "z", "6" => "b", "@" => "a", "$" => "s",
    "!" => "i", "?" => "c", "%" => "o", "*" => "a", "&" => "b", "#" => "h",
    "+" => "t", "=" => "e", "~" => "n", "_" => "t", "^" => "a", ":" => "i",
    ";" => "i", "|" => "i"
  }.freeze

  # rubocop:disable Metrics/BlockLength
  included do
    devise :database_authenticatable,
           :invitable,
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

    # Invitable
    field :invitation_token,       type: String
    field :invitation_created_at,  type: Time
    field :invitation_sent_at,     type: Time
    field :invitation_accepted_at, type: Time
    field :invitation_limit,       type: Integer

    index({ invitation_token: 1 }, background: true)
    index({ invitation_by_id: 1 }, background: true)

    ## Recoverable
    field :reset_password_token,   type: String
    field :reset_password_sent_at, type: Time

    ## Trackable
    field :sign_in_count,      type: Integer, default: 0
    field :current_sign_in_at, type: Time
    field :last_sign_in_at,    type: Time
    field :current_sign_in_ip, type: String
    field :last_sign_in_ip,    type: String

    ## Lockable
    field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
    field :unlock_token,    type: String # Only if unlock strategy is :email or :both
    field :locked_at,       type: Time

    # Validations
    validate :password_must_have_lowercase_uppercase_and_numeric
    validate :password_must_not_be_dictionary_word
    validate :password_must_not_contain_obvious_sequences
  end
  # rubocop:enable Metrics/BlockLength

  private

  def password_must_have_lowercase_uppercase_and_numeric
    return unless password.present? && errors[:password].empty?

    has_lowercase = (password =~ /[a-z]/)
    has_uppercase = (password =~ /[A-Z]/)
    has_numeric = (password =~ /[0-9]/)
    has_special = (password =~ /[^A-Za-z0-9]/)

    return true if has_lowercase && has_uppercase && (has_numeric || has_special)

    errors.add(:password, :invalid_format)
  end

  def password_must_not_be_dictionary_word
    return if password.blank?

    dictionary = File.read("./lib/words_alpha.txt").split("\n").map(&:strip)
    password_without_substitutions = simple_substitution_converter(password)
    return true unless dictionary.include?(password_without_substitutions.downcase)

    errors.add(:password, :dictionary_word)
  end

  def password_must_not_contain_obvious_sequences
    return if password.blank?

    sequences = %w[
      123 234 345 456 567 678 789 890 098 987 876 765 654 543 432 321 210 012 111
      222 333 444 555 666 777 888 999 000 abc bcd cde def efg fgh ghi hij ijk jkl
      klm lmn mno nop opq pqr qrs rst stu tuv uvw vwx wxy xyz yza zab
    ]
    return true unless sequences.any? { |s| password.include?(s) }

    errors.add(:password, :obvious_sequence)
  end

  def simple_substitution_converter(word)
    # match if any of the substitutions are present
    word_clone = word.strip.dup
    if word_clone =~ /[#{SUBSTITUTIONS.keys.join}]/
      # replace all the substitutions
      SUBSTITUTIONS.each do |k, v|
        word_clone.gsub!(k, v)
      end
    end

    word_clone
  end
end
