class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all
    elsif user.role? :customer
      can :read, Item
      can :show, Order do |order|
        order.customer_id == user.customer.id
      end
      can :show, Customer do |customer|
        customer.user_id == user.id
      end
      can :update, Customer do |customer|
        customer.user_id == user.id
      end
      can :show, User do |u|
        u.id == user.id
      end
      can :update, User do |u|
        u.id == user.id
      end
      can :index, Order do |order|
        order.customer_id == user.customer.id
      end
      can :checkout, Order do |order|
        order.customer_id == user.customer.id
      end
      can :create, Order
      can :add_to_cart, Order do |order|
        order.customer_id == user.customer.id
      end
      can :create, Address
      can :show, Address do |address|
        address.customer_id == user.customer.id
      end
      can :update, Address do |address|
        address.customer_id == user.customer.id
      end
      can :index, Address
    elsif user.role? :baker
      can :read, Item
      can :index, Order
    elsif user.role? :shipper
      can :read, Item
      can :read, Order
      can :show, Address
    else
      can :read, Item
      can :create, Customer
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
