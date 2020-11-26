class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, name: 'Dashboard', namespace_name: 'admin'
    # can :manage, Sales

    if user.admin?
      can :manage, :all
    elsif user.manager?
      can :manage, ActiveAdmin::Comment
      can :manage, Provider
      can :manage, Category
      can :manage, Product
      can :manage, PurchaseOrder
      can :make_request, PurchaseOrder
      can :paid, PurchaseOrder
    end
  end
end
