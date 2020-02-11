# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.deactivated?

    can :use_back_office, :all

    assign_agency_user_permissions(user)
    assign_finance_user_permissions(user)
  end

  private

  def assign_agency_user_permissions(user)
    permissions_for_agency_user if agency_user?(user)
    permissions_for_agency_user_with_refund if agency_user_with_refund?(user)
    permissions_for_agency_super_user if agency_super_user?(user)
    permissions_for_developer_user if developer?(user)
  end

  def assign_finance_user_permissions(user)
    permissions_for_finance_user if finance_user?(user)
    permissions_for_finance_admin_user if finance_admin_user?(user)
    permissions_for_finance_super_user if finance_super_user?(user)
  end

  # Permissions for specific roles

  def permissions_for_agency_user
    # This covers everything mounted in the engine and used for the assisted digital journey, including WorldPay
    can :update, WasteCarriersEngine::RenewingRegistration
    can :renew, :all
    can :view_certificate, WasteCarriersEngine::Registration
    can :order_copy_cards, WasteCarriersEngine::Registration
    can :edit, WasteCarriersEngine::Registration

    can :review_convictions, :all

    can :revert_to_payment_summary, :all

    can :transfer_registration, WasteCarriersEngine::Registration
  end

  def permissions_for_agency_user_with_refund
    permissions_for_agency_user

    can :view_revoked_reasons, :all
    can :cease, WasteCarriersEngine::Registration
    can :revoke, WasteCarriersEngine::Registration

    can :refund, :all
    can :record_cash_payment, :all
    can :record_cheque_payment, :all
    can :record_postal_order_payment, :all
    can :write_off_small, WasteCarriersEngine::FinanceDetails do |finance_details|
      finance_details.zero_difference_balance <= write_off_agency_user_cap
    end
  end

  def permissions_for_finance_user
    can :view_certificate, WasteCarriersEngine::Registration
    can :record_bank_transfer_payment, :all
  end

  def permissions_for_finance_admin_user
    can :charge_adjust, :all
    can :write_off_large, WasteCarriersEngine::FinanceDetails
    can :view_certificate, WasteCarriersEngine::Registration
    can :record_worldpay_missed_payment, :all
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

    # rubocop:disable Style/SymbolProc
    can :modify_user, User do |user|
      user.in_finance_group?
    end
    # rubocop:enable Style/SymbolProc
  end

  def permissions_for_developer_user
    permissions_for_agency_user

    can :import_conviction_data, :all
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

  def write_off_agency_user_cap
    @_write_off_agency_user_cap ||= WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i
  end
end
