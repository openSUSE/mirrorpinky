class ApplicationController < ActionController::Base
  before_filter :preload_regions, :set_current_user
  protect_from_forgery
  private
  def preload_regions
    @regions = Region.order(:name).load
  end

  # for model based access control
  def set_current_user
#    Authorization.current_user = current_user
  end

  def require_valid_user
    redirect_to new_user_ichain_session_path unless current_user
  end
end
