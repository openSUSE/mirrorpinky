class Admin::HomeController < ApplicationController
  def index
     @groups = current_user.groups.includes(:servers)
  end
end
