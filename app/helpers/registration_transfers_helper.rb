# frozen_string_literal: true

module RegistrationTransfersHelper
  # Used to check if the account has just been invited
  def newly_invited_account?(email)
    user = ExternalUser.where(email: email).first
    user.invitation_created_at.present? && user.invitation_accepted_at.blank?
  end

  def continue_after_transfer_link(registration)
    [Rails.configuration.wcrs_backend_url,
     "/registrations?utf8=%E2%9C%93&q=",
     registration.reg_identifier,
     "&commit=Search&searchWithin=any"].join
  end
end
