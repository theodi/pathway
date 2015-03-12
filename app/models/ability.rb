class Ability
  include CanCan::Ability
  
  def initialize(user)
    can :manage, :all if user.admin?
    can :manage, Assessment, :user_id => user.id
  end

end