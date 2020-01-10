# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    assign_agency_user_permissions(user)
    assign_finance_user_permissions(user)
  end

  private

  def assign_agency_user_permissions(user)
    permissions_for_agency_user if agency_user?(user)
    permissions_for_agency_user_with_refund if agency_user_with_refund?(user)
    permissions_for_agency_super_user if agency_super_user?(user)
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
    can :cease, WasteCarriersEngine::Registration
    can :revoke, WasteCarriersEngine::Registration
    can :renew, :all
    can :view_certificate, WasteCarriersEngine::Registration
    can :order_copy_cards, WasteCarriersEngine::Registration

    can :record_cash_payment, WasteCarriersEngine::RenewingRegistration
    can :record_cheque_payment, WasteCarriersEngine::RenewingRegistration
    can :record_postal_order_payment, WasteCarriersEngine::RenewingRegistration

    can :review_convictions, :all
    can :revoke, WasteCarriersEngine::Registration
    can :cease, WasteCarriersEngine::Registration

    can :revert_to_payment_summary, :all

    can :transfer_registration, WasteCarriersEngine::Registration
  end

  def permissions_for_agency_user_with_refund
    permissions_for_agency_user

    can :view_revoked_reasons, :all
    can :refund, :all
  end

  def permissions_for_finance_user
    can :view_certificate, WasteCarriersEngine::Registration
    can :record_transfer_payment, WasteCarriersEngine::RenewingRegistration
  end

  def permissions_for_finance_admin_user
    can :view_certificate, WasteCarriersEngine::Registration
    can :record_worldpay_missed_payment, WasteCarriersEngine::RenewingRegistration
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
    can :manage_back_office_users, User
    # rubocop:disable Style/SymbolProc
    can :modify_user, User do |user|
      user.in_finance_group?
    end
    # rubocop:enable Style/SymbolProc
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
end
