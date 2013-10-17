class Ability
  include CanCan::Ability

  def initialize(user)
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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= anonymous_user
    Rails.logger.debug("Current user #{user.inspect} with role #{user.role.inspect}")

    # things everyone should be able to do
    can :server, :list
    can :server, :index

    case user.role.title.to_sym
      when :admin then
        can :manage, :all
      when :user  then
        # access to /admin overview
        can :admin, :dashboard

        # resources
        can :read,    Group,    { id: user.group_ids     }
        can :manage,  Server,   { id: user.server_ids    }
        can :read,    RsyncAcl, { id: user.rsync_acl_ids }
        can :destroy, RsyncAcl, { id: user.rsync_acl_ids }
        # can :create, ServerRequest
        can :create, [:admin, GroupRequest]
        can :rsync_acl_request, :new
        can :rsync_acl_request, :create
        can :rsync_acl_request, :destroy
        can :create, RsyncAclRequest
        can :read,   RsyncAclRequest, { id: user.rsync_acl_request_ids }

        # dont have controller so we cant control them atm
        # can :read, Region
        # can :read, Marker
        # can :read, Country
      else
        # no more permissions than public server listing.
        # guest user can also access the devise controller so you can log in
    end
  end

  private
  def anonymous_user
    @cached_user ||= User.new(login: 'anonymous')
    @cached_user.role = Role.where(title: 'anonymous').first
    @cached_user
  end
end
