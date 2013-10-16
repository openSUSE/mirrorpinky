class Admin::HomeController < ApplicationController
  def index
     authorize! :admin, :dashboard
     @groups = current_user.groups.includes(:servers).order('server.identifier')
  end
end
