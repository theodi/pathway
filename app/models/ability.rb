class Ability
  include CanCan::Ability
  
  def initialize(user, token=nil)
    if user.present?
      can :manage, :all if user.admin?
      can :manage, Assessment, :user_id => user.id
    end
    can :read, Assessment, token: token
  end

end