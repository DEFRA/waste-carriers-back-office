# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.deactivated?

    can :use_back_office, :all

    assign_data_agent_user_permissions(user)
    assign_agency_user_permissions(user)
    assign_finance_user_permissions(user)
  end

  private

  def assign_data_agent_user_permissions(user)
    # Could assign here but assigned in a separate method to align with other permissions
    permissions_for_data_agent_user if data_agent?(user)
  end

  def assign_agency_user_permissions(user)
    permissions_for_agency_user if agency_user?(user)
    permissions_for_agency_user_with_refund if agency_user_with_refund?(user)
    permissions_for_agency_super_user if agency_super_user?(user)
    permissions_for_developer_user if developer?(user)
    permissions_for_cbd_user if cbd_user?(user)
  end

  def assign_finance_user_permissions(user)
    permissions_for_finance_user if finance_user?(user)
    permissions_for_finance_admin_user if finance_admin_user?(user)
    permissions_for_finance_super_user if finance_super_user?(user)
  end

  # Permissions for specific roles

  def permissions_for_data_agent_user
    can :view_certificate, WasteCarriersEngine::Registration
    can :view_revoked_reasons, :all
  end

  def permissions_for_agency_user
    # This covers everything mounted in the engine and used for the assisted digital journey, including WorldPay
    can :update, WasteCarriersEngine::RenewingRegistration
    can :create, WasteCarriersEngine::Registration
    can :renew, :all
    can :view_certificate, WasteCarriersEngine::Registration
    can :resend_confirmation_email, WasteCarriersEngine::Registration
    can :order_copy_cards, WasteCarriersEngine::Registration
    can :edit, WasteCarriersEngine::Registration
    can :refresh_company_name, WasteCarriersEngine::Registration

    can :revert_to_payment_summary, :all

    can :transfer_registration, [WasteCarriersEngine::Registration, RegistrationTransferPresenter]
  end

  def permissions_for_agency_user_with_refund
    permissions_for_agency_user

    can :view_revoked_reasons, :all
    can :cease, WasteCarriersEngine::Registration
    can :revoke, WasteCarriersEngine::Registration
    can :cancel, :all

    can :refund, :all
    can :record_cash_payment, :all
    can :record_cheque_payment, :all
    can :record_postal_order_payment, :all
    can :view_payments, :all
    can :review_convictions, :all
    can :view_card_order_exports, :all

    can :write_off_small, WasteCarriersEngine::FinanceDetails do |finance_details|
      finance_details.zero_difference_balance <= write_off_agency_user_cap
    end

    can :reverse, WasteCarriersEngine::Payment do |payment|
      payment.cash? || payment.postal_order? || payment.cheque?
    end
  end

  def permissions_for_finance_user
    can :view_certificate, WasteCarriersEngine::Registration
    can :record_bank_transfer_payment, :all

    can :view_payments, :all
    can :reverse, WasteCarriersEngine::Payment, &:bank_transfer?
  end

  def permissions_for_finance_admin_user
    can :charge_adjust, :all
    can :write_off_large, WasteCarriersEngine::FinanceDetails
    can :view_certificate, WasteCarriersEngine::Registration
    can :record_worldpay_missed_payment, :all
    can :view_payments, :all

    can :reverse, WasteCarriersEngine::Payment do |payment|
      payment.worldpay? || payment.worldpay_missed?
    end
  end

  def permissions_for_agency_super_user
    permissions_for_agency_user_with_refund

    can :manage_back_office_users, :all
    # rubocop:disable Style/SymbolProc
    can :modify_user, User do |user|
      user.in_agency_group?
    end
    # rubocop:enable Style/SymbolProc
  end

  def permissions_for_finance_super_user
    permissions_for_finance_admin_user

    can :manage_back_office_users, User
    can :charge_adjust, :all
    can :run_finance_reports, :all

    # rubocop:disable Style/SymbolProc
    can :modify_user, User do |user|
      user.in_finance_group?
    end
    # rubocop:enable Style/SymbolProc
  end

  def permissions_for_developer_user
    permissions_for_agency_user
    can :view_card_order_exports, :all

    can :manage, WasteCarriersEngine::FeatureToggle
    can :import_conviction_data, :all
    can :run_finance_reports, :all
  end

  def permissions_for_cbd_user
    permissions_for_agency_user

    can :import_conviction_data, :all
    can :run_finance_reports, :all
  end

  # Checks to see if role matches

  def agency_user?(user)
    user.role == "agency"
  end

  def agency_user_with_refund?(user)
    user.role == "agency_with_refund"
  end

  def finance_user?(user)
    user.role == "finance"
  end

  def finance_admin_user?(user)
    user.role == "finance_admin"
  end

  def agency_super_user?(user)
    user.role == "agency_super"
  end

  def finance_super_user?(user)
    user.role == "finance_super"
  end

  def developer?(user)
    user.role == "developer"
  end

  def cbd_user?(user)
    user.role == "cbd_user"
  end

  def data_agent?(user)
    user.role == "data_agent"
  end

  def write_off_agency_user_cap
    @_write_off_agency_user_cap ||= WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i
  end
end
# rubocop:enable Metrics/ClassLength
