# frozen_string_literal: true

class RegistrationTransferPresenter < WasteCarriersEngine::BasePresenter
  def initialize(registration)
    @registration = registration

    super
  end

  def new_registration_transfer_message_lines
    paragraph = []
    if @registration.account_email.present?
      paragraph << to_yml(:paragraph_1, email: @registration.account_email)
      paragraph << to_yml(:paragraph_2, reg_identifier: @registration.reg_identifier)
      paragraph << to_yml(:paragraph_3, email: @registration.account_email)
      paragraph << to_yml(:paragraph_4, email: @registration.account_email)
    else
      paragraph << to_yml(:paragraph_1_no_account_email)
      paragraph << to_yml(:paragraph_2, reg_identifier: @registration.reg_identifier)
    end
    paragraph
  end

  def account_email_message
    @registration.account_email.presence || to_yml("registration_info.values.not_applicable")
  end

  private

  def to_yml(key, options = {})
    I18n.t(".registration_transfers.new.#{key}", **options)
  end
end
