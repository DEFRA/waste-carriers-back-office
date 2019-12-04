# frozen_string_literal: true

class RegistrationConvictionPresenter < BaseConvictionPresenter
  def display_actions?
    conviction_check_required?
  end
end
