class Ability
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new # guest user
 
    if user.role? :super_admin
      can :manage, :all
      can :access_panel, User
    elsif user.role? :writer
      can :manage, :all
      can :access_panel, User
      cannot [:read, :update, :create, :destroy], Role
    else
      cannot [:update, :create, :destroy], Article
    end
  end
end
