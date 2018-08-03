# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(_user)
    can :read, WasteCarriersEngine::Registration
    can :manage, WasteCarriersEngine::TransientRegistration
  end
end
