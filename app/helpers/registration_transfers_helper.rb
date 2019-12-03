# frozen_string_literal: true

module RegistrationTransfersHelper
  # Used to check if the account has just been invited
  def newly_invited_account?(email)
    user = ExternalUser.where(email: email).first
    user.invitation_created_at.present? && user.invitation_accepted_at.blank?
  end
end
