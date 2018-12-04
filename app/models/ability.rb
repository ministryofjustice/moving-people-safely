# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Escort do |escort|
      user.can_access_escort?(escort)
    end
    can :update, Escort do |escort|
      escort.editable? && user.can_access_escort?(escort)
    end
    if user.admin? || user.police?
      can :manage, Healthcare, editable?: true
      can :manage, Risk, editable?: true
      can :manage, OffencesWorkflow, editable?: true
    elsif user.healthcare?
      can :manage, Healthcare, editable?: true
    else
      can :manage, Risk, editable?: true
      can :manage, OffencesWorkflow, editable?: true
    end
  end
end
