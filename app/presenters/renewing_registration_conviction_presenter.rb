# frozen_string_literal: true

class RenewingRegistrationConvictionPresenter < BaseConvictionPresenter
  def display_actions?
    renewal_application_submitted? && conviction_check_required?
  end
end
