# frozen_string_literal: true

class RegistrationTransferPresenter < WasteCarriersEngine::BasePresenter
  def initialize(registration)
    @registration = registration

    super
  end

  def paragraph_1_message
    if @registration.account_email.present?
      I18n.t(".registration_transfers.new.paragraph_1", email: @registration.account_email)
    else
      I18n.t(".registration_transfers.new.paragraph_1_no_account_email")
    end
  end

  def account_email_message
    @registration.account_email.presence ||
      I18n.t(".registration_transfers.new.registration_info.values.not_applicable")
  end
end
