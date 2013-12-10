class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.persisted?
      can :manage, :all
    else
      can :show, Trim::NavItem
      can :show, Trim::Page, :is_private => false
    end
  end
end
