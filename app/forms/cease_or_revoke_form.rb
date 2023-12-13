# frozen_string_literal: true

class CeaseOrRevokeForm < WasteCarriersEngine::BaseForm
  def self.can_navigate_flexibly?
    false
  end

  delegate :metaData, to: :transient_registration
  delegate :status, :revoked_reason, to: :metaData, allow_nil: true
  delegate :contact_address, :company_name, :registration_type, :tier, to: :transient_registration

  validate :validate_status
  validate :validate_revoked_reason

  private

  def validate_status
    return true if %w[INACTIVE REVOKED].include?(status)

    errors.add(:status, :presence)

    false
  end

  def validate_revoked_reason
    if revoked_reason.blank?
      errors.add(:revoked_reason, :presence)

      false
    elsif revoked_reason.size > 500
      errors.add(:revoked_reason, :length)

      false
    end

    true
  end
end
