# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, WasteCarriersEngine::Registration
    can :update, WasteCarriersEngine::TransientRegistration

    permissions_for_agency_user_group if in_agency_user_group?(user)
    permissions_for_finance_user if finance_user?(user)
    permissions_for_finance_admin_user if finance_admin_user?(user)
    permissions_for_agency_super_user if agency_super_user?(user)
    permissions_for_finance_super_user if finance_super_user?(user)
  end

  private

  # Permissions for specific roles

  def permissions_for_agency_user_group
    can :renew_registration, WasteCarriersEngine::TransientRegistration
    can :take_worldpay_payment, WasteCarriersEngine::TransientRegistration

    can :record_cash_payment, WasteCarriersEngine::TransientRegistration
    can :record_cheque_payment, WasteCarriersEngine::TransientRegistration
    can :record_postal_order_payment, WasteCarriersEngine::TransientRegistration

    can :review_convictions, WasteCarriersEngine::TransientRegistration
  end

  def permissions_for_finance_user
    can :record_electronic_transfer_payment, WasteCarriersEngine::TransientRegistration
  end

  def permissions_for_finance_admin_user
    can :record_worldpay_payment, WasteCarriersEngine::TransientRegistration
  end

  def permissions_for_agency_super_user
    can :create_agency_user, User
  end

  def permissions_for_finance_super_user
    can :create_agency_user, User
    can :create_agency_with_refund_user, User
    can :create_finance_user, User
    can :create_finance_admin_user, User
  end

  # Checks to see if role matches

  def in_agency_user_group?(user)
    %w[agency agency_with_refund].include?(user.role)
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
