# frozen_string_literal: true

class RenewingRegistrationConvictionPresenter < BaseConvictionPresenter
  def display_actions?
    renewal_application_submitted? && conviction_check_required?
  end

  def begin_checks_path
    Rails.application.routes.url_helpers.transient_registration_convictions_begin_checks_path(reg_identifier)
  end
 
  def approve_path
    Rails.application.routes.url_helpers.new_transient_registration_conviction_approval_form_path(reg_identifier)
  end

  def reject_path
    Rails.application.routes.url_helpers.new_transient_registration_conviction_rejection_form_path(reg_identifier)
  end
end
