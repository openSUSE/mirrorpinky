class Admin::HomeController < ApplicationController
  def index
     authorize! :admin, :dashboard
     @groups = current_user.groups.includes(:servers).order('server.identifier')
     @group_requests = current_user.group_requests
  end
end
